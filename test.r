options(java.parameters = "-Xmx8g")  # must be set before rJava/dismo starts the JVM

library(readr)
library(dplyr)
library(raster)
library(dismo)
library(maps)
library(leaflet)

t_start <- Sys.time()

# --- Step 1: config ----------------------------------------------------------
set.seed(1964)  # reproducibility for R-side sampling (e.g. Step 10 background draw)

base_dir     <- "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee"
baseline_dir <- file.path(base_dir, "Baseline", "2000")
species_name <- "Acacia georginae"

preview_dir       <- "output/00_raster_preview"
maxent_output_dir <- "output/01_current_maxent"
dir.create(preview_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(maxent_output_dir, recursive = TRUE, showWarnings = FALSE)

# --- Step 2: load & clean occurrence points -----------------------------------
occ <- read_csv(
  file.path(base_dir, "SpeciesOccurence_clean.csv"),
  show_col_types = FALSE
) %>%
  filter(Species == species_name) %>%
  dplyr::select(Longitude, Latitude) %>%
  distinct() %>%
  filter(!is.na(Longitude), !is.na(Latitude))

cat("Step 2: occurrence loaded, nrow(occ) =", nrow(occ), "\n")

# --- Step 3: predictor stack (specific bioclim subset, not all 19) + PNG preview ---
raster_paths <- c(
  file.path(baseline_dir, "soil.asc"),
  file.path(baseline_dir, "ibra.asc"),
  file.path(baseline_dir, "bioclim_01.asc"),
  file.path(baseline_dir, "bioclim_04.asc"),
  file.path(baseline_dir, "bioclim_05.asc"),
  file.path(baseline_dir, "bioclim_06.asc"),
  file.path(baseline_dir, "bioclim_07.asc"),
  file.path(baseline_dir, "bioclim_12.asc"),
  file.path(baseline_dir, "bioclim_13.asc"),
  file.path(baseline_dir, "bioclim_14.asc"),
  file.path(baseline_dir, "bioclim_15.asc")
)

raster_stack <- stack(raster_paths)
names(raster_stack) <- gsub("\\.asc$", "", basename(raster_paths))

for (nm in names(raster_stack)) {
  png(file.path(preview_dir, paste0(nm, ".png")), width = 1200, height = 1000, res = 150)
  plot(raster_stack[[nm]], main = nm)
  maps::map("world", regions = "Australia", add = TRUE, col = "grey60", border = "grey40")
  dev.off()
}
cat("Step 3: predictor stack built, preview PNGs written to", preview_dir, "\n")

# --- Step 3b: study area extent ------------------------------------------------
# Official study area = union of these 13 IBRA7 subregions:
ibra7_regions <- c(
  BRT = "Burt Plain",              MGD = "Mitchell Grass Downs",
  CHC = "Channel Country",         MII = "Mount Isa Inlier",
  DEU = "Desert Uplands",          MUL = "Mulga Lands",
  DMR = "Davenport Murchison Ranges", SSD = "Simpson Strzelecki Dunefields",
  FIN = "Finke",                   STP = "Stony Plains",
  GSD = "Great Sandy Desert",      TAN = "Tanami",
  MAC = "MacDonnell Ranges"
)
# NOTE: ibra.asc holds 87 arbitrary integer codes with no legend/attribute
# table in this data package, so the exact codes for these 13 regions can't
# be recovered from the raster alone (see chat). Using a buffered bounding
# box around the occurrence records as a practical stand-in study extent
# until the actual IBRA7 polygons (with REG_CODE_7) are available to crop by
# name properly.
buffer_deg <- 2   # ~200 km padding around the occurrence records

study_extent <- extent(
  min(occ$Longitude) - buffer_deg, max(occ$Longitude) + buffer_deg,
  min(occ$Latitude)  - buffer_deg, max(occ$Latitude)  + buffer_deg
)

raster_stack <- crop(raster_stack, study_extent)
cat("Step 3b: cropped to study extent (", paste(round(as.vector(study_extent), 2), collapse = ", "), ")\n")
raster_stack

png(file.path(preview_dir, "study_area_extent.png"), width = 1200, height = 1000, res = 150)
maps::map("world", regions = "Australia", col = "grey85", fill = TRUE, border = "grey50",
          xlim = c(study_extent@xmin - 3, study_extent@xmax + 3),
          ylim = c(study_extent@ymin - 3, study_extent@ymax + 3))
plot(study_extent, add = TRUE, col = "red", lwd = 2)
points(occ$Longitude, occ$Latitude, pch = 20, col = adjustcolor("darkgreen", 0.5), cex = 0.6)
title("Study area extent vs. occurrence records\n(bbox proxy for the 13 IBRA7 regions - see note in script)")
dev.off()
cat("Step 3b: study_area_extent.png written\n")



# --- Step 4: ibra and soil are region/class codes -> treat as categorical ----
raster_stack$ibra <- as.factor(raster_stack$ibra)
raster_stack$soil <- as.factor(raster_stack$soil)

# --- Step 5: drop occurrence points that fall outside the raster / on NA cells ---
occ_vals <- raster::extract(raster_stack[[1]], occ)
occ <- occ[!is.na(occ_vals), ]
cat("Step 5: after NA-drop, nrow(occ) =", nrow(occ), "\n")

# --- Step 6: fit MaxEnt -------------------------------------------------------
t0 <- Sys.time()
mx <- maxent(
  x       = raster_stack,
  p       = as.data.frame(occ),
  factors = c("ibra", "soil"),   # dismo drops factor-ness on extract() otherwise
  path    = maxent_output_dir,
  args = c(
    "autofeature=true",
    "linear=true", "quadratic=true", "product=true", "hinge=true", "threshold=true",
    "jackknife=false",
    "betamultiplier=1",
    "beta_lqp=-1", "beta_hinge=-1", "beta_threshold=-1", "beta_categorical=-1",
    "maximumbackground=10000",
    "maximumiterations=500",
    "convergencethreshold=0.00001",
    "replicates=1",
    "replicatetype=crossvalidate",
    "randomtestpoints=0",
    "randomseed=true"
  )
)
t_maxent <- Sys.time() - t0
cat("Step 6: maxent fit done in", round(as.numeric(t_maxent, units = "secs"), 1), "sec\n")

# --- Step 7: model summary ----------------------------------------------------
print(mx)
print(mx@results)

# --- Step 8: predict suitability surface + save PNG ---------------------------
pred <- predict(mx, raster_stack)

png(file.path(maxent_output_dir, "suitability_current.png"), width = 1200, height = 1000, res = 150)
plot(pred, main = "Predicted suitability - current climate")
maps::map("world", regions = "Australia", add = TRUE, col = "grey60", border = "grey40")
dev.off()
cat("Step 8: suitability PNG written\n")

# --- Step 9: interactive leaflet view of the suitability raster ---------------
pal <- colorNumeric("YlOrRd", values(pred), na.color = "transparent")

suit_map <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addRasterImage(pred, colors = pal, opacity = 0.75) %>%
  addLegend(pal = pal, values = values(pred), title = "Suitability")

htmlwidgets::saveWidget(suit_map, file.path(normalizePath(maxent_output_dir), "suitability_map.html"), selfcontained = TRUE)
cat("Step 9: leaflet map saved to", file.path(maxent_output_dir, "suitability_map.html"), "\n")
suit_map   # in a notebook cell, this renders the interactive map inline

# --- Step 10: model evaluation - AUC / ROC curve -------------------------------
set.seed(1)
bg   <- randomPoints(raster_stack, 1000)
eval <- evaluate(p = as.data.frame(occ), a = bg, model = mx, x = raster_stack)

png(file.path(maxent_output_dir, "roc_curve.png"), width = 900, height = 900, res = 150)
plot(eval, "ROC")
dev.off()
cat("Step 10: ROC curve written, AUC =", round(eval@auc, 3), "\n")

# --- Step 11: response curves --------------------------------------------------
png(file.path(maxent_output_dir, "response_curves.png"), width = 1600, height = 1200, res = 150)
response(mx)
dev.off()
cat("Step 11: response curves written\n")

# --- Step 12: variable importance plot (Maxent's own permutation importance) --
vip_rows <- mx@results[grepl("permutation\\.importance$", rownames(mx@results)), , drop = FALSE]
vip_df <- data.frame(
  variable   = gsub("\\.permutation\\.importance", "", rownames(vip_rows)),
  importance = as.numeric(vip_rows[, 1])
)
vip_df <- vip_df[order(vip_df$importance), ]

png(file.path(maxent_output_dir, "variable_importance.png"), width = 1200, height = 900, res = 150)
par(mar = c(4, 8, 3, 2))
barplot(vip_df$importance, names.arg = vip_df$variable, horiz = TRUE, las = 1,
        main = "Permutation importance", xlab = "%")
dev.off()
cat("Step 12: variable importance plot written\n")

# --- Step 13: run summary with timestamps (always last) -----------------------
t_end <- Sys.time()
cat("\n---- run summary ----\n")
cat("started  :", format(t_start, "%Y-%m-%d %H:%M:%S"), "\n")
cat("finished :", format(t_end,   "%Y-%m-%d %H:%M:%S"), "\n")
cat("maxent fit time :", round(as.numeric(t_maxent, units = "secs"), 1), "sec\n")
cat("total run time  :", round(as.numeric(t_end - t_start, units = "secs"), 1), "sec\n")