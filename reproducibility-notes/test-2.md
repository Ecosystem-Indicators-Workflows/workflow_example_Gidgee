# Test 2
JR Ferrer-Paris
2026-11-02

Running on head with sha `2212dc7ea82a2d222c2cbcc8d59858afce931bc0`

I cloned the repository using `git clone ...`.

Changed to folder `cd workflow_example_Gidgee`

Switched to new branch with `git checkout -b test-repro-linux`

Then ran in bash terminal:

``` bash
quarto render Gidgee_workflow_2026.qmd --output-dir docs  --output index.html
```

> [!WARNING]
>
> Failed: hit several memory errors!

Apparently the errors had to do with the local installation of quarto
and certain R packages.

***Fix***:

- download latest version of quarto, then
  `sudo dpkg -i quarto-1.11.8-linux-amd64.deb`
- updated packages in ubuntu using the Software Updater
- updated R packages in R: `update.packages()`

> [!NOTE]
>
> After those updates, it finally Succeeded!

# Context of the successful run

``` markdown
# Resource usage

## Time
Start:   2026-11-02 16:31:28
End:     2026-11-02 16:36:57
Elapsed: 329.4 seconds (5.5 minutes)

## Compute
Peak R heap used: 954 MB (gc() "max used", since the reset in the first chunk)
Note: this covers R's own heap only, not the separate JVM heap dismo::maxent()
  allocates via rJava (capped at -Xmx8g by options(java.parameters = ...) in the
  first chunk) — the true peak process memory is higher than the figure above.
CPU cores available: 20
Peak R heap as share of system RAM: unknown (system RAM not detected)

## Storage
Input data (data/raw/):            2764 MB
Outputs (results/ + provenance/):  33.9 MB
Total footprint this run touched:  2798 MB
```

## My session info

``` r
─ Session info ───────────────────────────────────────────────────────────────
 setting  value
 version  R version 4.6.2 (2026-10-29)
 os       Ubuntu 22.04.5 LTS
 system   x86_64, linux-gnu
 ui       X11
 language en_AU:en
 collate  en_AU.UTF-8
 ctype    en_AU.UTF-8
 tz       Australia/Sydney
 date     2026-11-02
 pandoc   2.9.2.1 @ /usr/bin/ (via rmarkdown)
 quarto   1.10.20 @ /usr/local/bin/quarto

─ Packages ───────────────────────────────────────────────────────────────────
 package           * version date (UTC) lib source
 bit                 4.6.0   2025-03-06 [3] RSPM (R 4.4.0)
 bit64               4.8.6   2026-09-01 [3] CRAN (R 4.6.1)
 bspm                0.5.8   2026-01-29 [1] CRAN (R 4.6.2)
 class               7.3-24  2026-08-03 [3] CRAN (R 4.6.1)
 classInt            0.4-11  2025-01-08 [3] RSPM (R 4.4.0)
 cli                 3.6.6   2026-04-09 [3] CRAN (R 4.5.3)
 codetools           0.2-20  2024-03-31 [3] RSPM (R 4.3.0)
 crayon              1.5.3   2024-06-20 [3] RSPM (R 4.4.0)
 crosstalk           1.2.2   2025-08-26 [3] RSPM (R 4.5.0)
 curl                8.1.0   2026-10-14 [3] CRAN (R 4.6.1)
 DBI                 1.3.0   2026-02-25 [3] CRAN (R 4.5.2)
 digest            * 0.6.39  2025-11-19 [3] CRAN (R 4.5.2)
 dismo             * 1.3-16  2024-11-25 [3] RSPM (R 4.4.0)
 dplyr             * 1.2.1   2026-04-03 [3] CRAN (R 4.5.3)
 e1071               1.7-17  2025-12-18 [3] CRAN (R 4.5.2)
 evaluate            1.0.5   2025-08-27 [3] RSPM (R 4.5.0)
 farver              2.1.2   2024-05-13 [3] RSPM (R 4.4.0)
 fastmap             1.2.0   2024-05-15 [3] RSPM (R 4.4.0)
 fs                * 2.1.0   2026-04-18 [3] CRAN (R 4.5.3)
 gargle              1.7.0   2026-10-28 [3] CRAN (R 4.6.1)
 generics            0.1.4   2025-05-09 [3] RSPM (R 4.5.0)
 glue                1.8.1   2026-04-17 [3] CRAN (R 4.5.3)
 googledrive       * 2.2.0   2026-10-29 [3] CRAN (R 4.6.1)
 hms                 1.1.4   2025-10-17 [3] RSPM (R 4.5.0)
 htmltools           0.5.9   2025-12-04 [3] CRAN (R 4.5.2)
 htmlwidgets         1.6.4   2023-12-06 [3] RSPM (R 4.3.0)
 httr                1.4.9   2026-09-01 [3] CRAN (R 4.6.1)
 jquerylib           0.1.4   2021-04-26 [3] RSPM (R 4.3.2)
 jsonlite            2.0.0   2025-03-27 [3] RSPM (R 4.4.0)
 KernSmooth          2.23-27 2026-08-12 [3] CRAN (R 4.6.1)
 knitr               1.52    2026-09-06 [3] CRAN (R 4.6.1)
 lattice             0.23-1  2026-08-12 [3] CRAN (R 4.6.1)
 leaflet           * 2.2.3   2025-09-04 [3] RSPM (R 4.5.0)
 leaflet.providers   3.0.0   2026-03-18 [3] CRAN (R 4.5.3)
 lifecycle           1.0.5   2026-01-08 [3] CRAN (R 4.5.2)
 magrittr            2.0.5   2026-04-04 [3] CRAN (R 4.5.3)
 maps              * 3.4.4   2026-10-23 [3] CRAN (R 4.6.1)
 otel                0.2.0   2025-08-29 [3] RSPM (R 4.5.0)
 pillar              1.11.1  2025-09-17 [3] RSPM (R 4.5.0)
 pkgconfig           2.0.3   2019-09-22 [3] CRAN (R 4.0.1)
 png                 0.1-9   2026-03-15 [3] CRAN (R 4.5.2)
 proxy               0.4-29  2025-12-29 [3] CRAN (R 4.5.2)
 purrr               1.2.2   2026-04-10 [3] CRAN (R 4.5.3)
 R6                  2.6.1   2025-02-15 [3] RSPM (R 4.4.0)
 raster            * 3.6-32  2025-03-28 [3] RSPM (R 4.4.0)
 RColorBrewer        1.1-3   2022-04-03 [3] RSPM (R 4.2.0)
 Rcpp                1.1.2   2026-07-05 [3] CRAN (R 4.6.0)
 readr             * 2.2.0   2026-02-19 [3] CRAN (R 4.5.2)
 rJava               1.0-18  2026-04-08 [3] CRAN (R 4.5.3)
 rlang               1.3.0   2026-07-05 [3] CRAN (R 4.6.0)
 rmarkdown           2.32    2026-09-01 [3] CRAN (R 4.6.1)
 scales              1.4.0   2025-04-24 [3] RSPM (R 4.4.0)
 sessioninfo       * 1.2.4   2026-06-04 [3] CRAN (R 4.6.0)
 sf                * 1.1-3   2026-09-11 [3] CRAN (R 4.6.1)
 sp                * 2.2-4   2026-10-11 [3] CRAN (R 4.6.1)
 terra               1.9-50  2026-09-08 [1] CRAN (R 4.6.2)
 tibble              3.3.1   2026-01-11 [3] CRAN (R 4.5.2)
 tidyselect          1.2.1   2024-03-11 [3] RSPM (R 4.3.0)
 tzdb                0.5.0   2025-03-15 [3] RSPM (R 4.4.0)
 units               1.0-1   2026-03-11 [3] CRAN (R 4.5.2)
 vctrs               0.7.3   2026-04-11 [3] CRAN (R 4.6.0)
 vroom               1.7.1   2026-03-31 [3] CRAN (R 4.6.0)
 xfun                0.62    2026-10-16 [3] CRAN (R 4.6.1)
 xml2              * 1.6.0   2026-06-22 [3] CRAN (R 4.6.0)
 yaml                2.3.12  2025-12-10 [3] CRAN (R 4.6.0)

 [1] /home/jferrer/R/x86_64-pc-linux-gnu-library/4.6
 [2] /usr/local/lib/R/site-library
 [3] /usr/lib/R/site-library
 [4] /usr/lib/R/library
 * ── Packages attached to the search path.

──────────────────────────────────────────────────────────────────────────────
```
