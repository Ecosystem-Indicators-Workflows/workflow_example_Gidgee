# Test 1.1
Elliot Gould
2026-10-30

Running on head with sha `699dd438b10a63d2080ac3c1066689a3954a9a47`

I cloned the repository using GitHub Desktop v3.6.4. (arm64). Was
prompted to initialise repo with LFS in the GUI. Accepted. Switched to
branch test-reproducibility.

Then ran in terminal from within poisitron opened to root dir of repo.

``` bash
quarto render Gidgee_workflow_2026.qmd
```

> [!NOTE]
>
> First try succeeded!

# Context of the successful run

``` markdown
# Resource usage

## Time
Start:   2026-10-30 15:04:13
End:     2026-10-30 15:12:35
Elapsed: 501.7 seconds (8.4 minutes)

## Compute
Peak R heap used: 1017 MB (gc() "max used", since the reset in the first chunk)
Note: this covers R's own heap only, not the separate JVM heap dismo::maxent()
  allocates via rJava (capped at -Xmx8g by options(java.parameters = ...) in the
  first chunk) — the true peak process memory is higher than the figure above.
CPU cores available: 8
System RAM: 32.0 GB
Peak R heap as share of system RAM: 3.1% (0.99 GB of 32.0 GB available)

## Storage
Input data (data/raw/):            2764 MB
Outputs (results/ + provenance/):  34.0 MB
Total footprint this run touched:  2798 MB
```

## My session info

``` r
─ Session info ───────────────────────────────────────────────────────────────
 setting  value
 version  R version 4.5.2 (2025-10-31)
 os       macOS Tahoe 26.5.1
 system   aarch64, darwin20
 ui       X11
 language (EN)
 collate  en_US.UTF-8
 ctype    en_US.UTF-8
 tz       Australia/Melbourne
 date     2026-10-30
 pandoc   3.10 @ /Applications/Positron.app/Contents/Resources/app/quarto/bin/tools/aarch64/ (via rmarkdown)
 quarto   1.9.37 @ /Applications/quarto/bin/quarto

─ Packages ───────────────────────────────────────────────────────────────────
 package           * version   date (UTC) lib source
 bit                 4.6.0     2025-03-06 [1] CRAN (R 4.5.0)
 bit64               4.8.2     2026-05-19 [1] CRAN (R 4.5.2)
 class               7.3-23    2025-01-01 [1] CRAN (R 4.5.2)
 classInt            0.4-11    2025-01-08 [1] CRAN (R 4.5.0)
 cli                 3.6.6     2026-04-09 [1] CRAN (R 4.5.2)
 codetools           0.2-20    2024-03-31 [1] CRAN (R 4.5.2)
 crayon              1.5.3     2024-06-20 [1] CRAN (R 4.5.0)
 crosstalk           1.2.2     2025-08-26 [1] CRAN (R 4.5.0)
 curl                7.1.0     2026-04-22 [1] CRAN (R 4.5.2)
 DBI                 1.3.0     2026-02-25 [1] CRAN (R 4.5.2)
 dichromat           2.0-0.1   2022-05-02 [1] CRAN (R 4.5.0)
 digest            * 0.6.39    2025-11-19 [1] CRAN (R 4.5.2)
 dismo             * 1.3-16    2024-11-25 [1] CRAN (R 4.5.0)
 dplyr             * 1.2.1     2026-04-03 [1] CRAN (R 4.5.2)
 e1071               1.7-17    2025-12-18 [1] CRAN (R 4.5.2)
 evaluate            1.0.5     2025-08-27 [1] CRAN (R 4.5.0)
 farver              2.1.2     2024-05-13 [1] CRAN (R 4.5.0)
 fastmap             1.2.0     2024-05-15 [1] CRAN (R 4.5.0)
 fs                * 2.1.0     2026-04-18 [1] CRAN (R 4.5.2)
 gargle              1.6.1     2026-01-29 [1] CRAN (R 4.5.2)
 generics            0.1.4     2025-05-09 [1] CRAN (R 4.5.0)
 glue                1.8.1     2026-04-17 [1] CRAN (R 4.5.2)
 googledrive       * 2.1.2     2025-09-10 [1] CRAN (R 4.5.0)
 hms                 1.1.4     2025-10-17 [1] CRAN (R 4.5.0)
 htmltools           0.5.9     2025-12-04 [1] CRAN (R 4.5.2)
 htmlwidgets         1.6.4     2023-12-06 [1] CRAN (R 4.5.0)
 httr                1.4.8     2026-02-13 [1] CRAN (R 4.5.2)
 jquerylib           0.1.4     2021-04-26 [1] CRAN (R 4.5.0)
 jsonlite            2.0.0     2025-03-27 [1] CRAN (R 4.5.0)
 KernSmooth          2.23-26   2025-01-01 [1] CRAN (R 4.5.2)
 knitr               1.51      2025-12-20 [1] CRAN (R 4.5.2)
 lattice             0.22-9    2026-02-09 [1] CRAN (R 4.5.2)
 leaflet           * 2.2.3     2025-09-04 [1] CRAN (R 4.5.0)
 leaflet.providers   3.0.0     2026-03-18 [1] CRAN (R 4.5.2)
 lifecycle           1.0.5     2026-01-08 [1] CRAN (R 4.5.2)
 magrittr            2.0.5     2026-04-04 [1] CRAN (R 4.5.2)
 maps              * 3.4.3     2025-05-26 [1] CRAN (R 4.5.0)
 otel                0.2.0     2025-08-29 [1] CRAN (R 4.5.0)
 pillar              1.11.1    2025-09-17 [1] CRAN (R 4.5.0)
 pkgconfig           2.0.3     2019-09-22 [1] CRAN (R 4.5.0)
 png                 0.1-9     2026-03-15 [1] CRAN (R 4.5.2)
 proxy               0.4-29    2025-12-29 [1] CRAN (R 4.5.2)
 purrr               1.2.2     2026-04-10 [1] CRAN (R 4.5.2)
 R6                  2.6.1     2025-02-15 [1] CRAN (R 4.5.0)
 raster            * 3.6-32    2025-03-28 [1] CRAN (R 4.5.0)
 RColorBrewer        1.1-3     2022-04-03 [1] CRAN (R 4.5.0)
 Rcpp                1.1.1-1.1 2026-04-24 [1] RSPM (R 4.5.0)
 readr             * 2.2.0     2026-02-19 [1] CRAN (R 4.5.2)
 rJava               1.0-11    2024-01-26 [1] CRAN (R 4.5.0)
 rlang               1.3.0     2026-07-05 [1] CRAN (R 4.5.2)
 rmarkdown           2.31      2026-03-26 [1] CRAN (R 4.5.2)
 scales              1.4.0     2025-04-24 [1] CRAN (R 4.5.0)
 sessioninfo       * 1.2.4     2026-06-04 [1] CRAN (R 4.5.2)
 sf                * 1.1-2     2026-07-23 [1] CRAN (R 4.5.2)
 sp                * 2.2-1     2026-02-13 [1] RSPM (R 4.5.0)
 terra               1.9-46    2026-08-22 [1] CRAN (R 4.5.2)
 tibble              3.3.1     2026-01-11 [1] CRAN (R 4.5.2)
 tidyselect          1.2.1     2024-03-11 [1] CRAN (R 4.5.0)
 tzdb                0.5.0     2025-03-15 [1] CRAN (R 4.5.0)
 units               1.0-1     2026-03-11 [1] CRAN (R 4.5.2)
 vctrs               0.7.3     2026-04-11 [1] CRAN (R 4.5.2)
 vroom               1.7.1     2026-03-31 [1] CRAN (R 4.5.2)
 xfun                0.59      2026-06-19 [1] CRAN (R 4.5.2)
 xml2              * 1.5.2     2026-01-17 [1] CRAN (R 4.5.2)
 yaml                2.3.12    2025-12-10 [1] CRAN (R 4.5.2)

 [1] /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library
 * ── Packages attached to the search path.

──────────────────────────────────────────────────────────────────────────────
```
