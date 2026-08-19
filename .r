library(readr)
library(dplyr)
library(raster)
library(dismo)

t_start <- Sys.time()

# --- config ---------------------------------------------------------------
# zip_path     <- "Data_IUCNGeorginaGidgee.zip"   # bundled in this repo
data_dir     <- "data/IUCNGeorginaGidgee"        # local extraction cache (gitignored)
output_dir   <- "output/01_current_maxent"
species_name <- "Acacia georginae"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# --- raster preview: bring in the climate and land layers, then save PNG basemaps ---
if (!requireNamespace("maps", quietly = TRUE)) {
  install.packages("maps", repos = "https://cloud.r-project.org")
}
library(maps)

raster_paths <- c(
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/soil.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/ibra.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_01.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_04.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_05.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_06.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_07.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_12.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_13.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_14.asc",
  "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee/Baseline/2000/bioclim_15.asc"
)

raster_stack <- stack(raster_paths)
names(raster_stack) <- gsub("\\.asc$", "", basename(raster_paths))

output_dir <- "output/00_raster_preview"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

for (nm in names(raster_stack)) {
  r <- raster_stack[[nm]]
  png(file.path(output_dir, paste0(nm, ".png")), width = 1200, height = 1000, res = 150)
  plot(r, main = nm)
  maps::map("world", regions = c("Australia"), add = TRUE, col = "grey60", border = "grey40")
  dev.off()
}

raster_stack

plot(raster_stack)

raster_stack$ibra <- as.factor(raster_stack$ibra)
raster_stack$soil <- as.factor(raster_stack$soil)


library(readr)
library(dplyr)
library(raster)
library(dismo)
library(maps)

t_start <- Sys.time()

# --- Step 1: config --------------------------------------------------------
base_dir     <- "/Users/ecocommons/Downloads/02_EIW/Test_workflow/Gidgee/IUCNGeorginaGidgee"
baseline_dir <- file.path(base_dir, "Baseline", "2000")
species_name <- "Acacia georginae"

preview_dir       <- "output/00_raster_preview"
maxent_output_dir <- "output/01_current_maxent"
dir.create(preview_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(maxent_output_dir, recursive = TRUE, showWarnings = FALSE)

# --- Step 2: load & clean occurrence points --------------------------------
occ <- read_csv(
  file.path(base_dir, "SpeciesOccurence_clean.csv"),
  show_col_types = FALSE
) %>%
  filter(Species == species_name) %>%
  dplyr::select(Longitude, Latitude) %>%
  distinct() %>%
  filter(!is.na(Longitude), !is.na(Latitude))

cat("Step: occurrence loaded, nrow(occ) =", nrow(occ), "\n")
head(occ)

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
  r <- raster_stack[[nm]]
  png(file.path(preview_dir, paste0(nm, ".png")), width = 1200, height = 1000, res = 150)
  plot(r, main = nm)
  maps::map("world", regions = "Australia", add = TRUE, col = "grey60", border = "grey40")
  dev.off()
}
cat("Step: preview PNGs written to", preview_dir, "\n")

# --- Step 4: ibra and soil are region/class codes, not continuous climate -> treat as categorical ---
raster_stack$ibra <- as.factor(raster_stack$ibra)
raster_stack$soil <- as.factor(raster_stack$soil)
print(raster_stack)

# --- Step 5: drop occurrence points that fall outside the raster / on NA cells ---
occ_vals <- raster::extract(raster_stack[[1]], occ)
occ <- occ[!is.na(occ_vals), ]
cat("Step: after NA-drop, nrow(occ) =", nrow(occ), "\n")

# --- Step 6: fit MaxEnt -----------------------------------------------------
t0 <- Sys.time()
mx <- maxent(
  x    = raster_stack,
  p    = as.data.frame(occ),
  path = maxent_output_dir,
  args = c("maximumiterations=5000")
)
t_maxent <- Sys.time() - t0

# --- Step 7: inspect results + timing ---------------------------------------
cat("maxent fit done in", as.numeric(t_maxent, units = "secs"), "sec\n")
print(mx)
print(mx@results)

t_end <- Sys.time()
cat("Step: total script time", as.numeric(t_end - t_start, units = "secs"), "sec\n")