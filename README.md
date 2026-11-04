## Acknowledgments:
This workflow reproduces and extends TERN CoESRA Case Study 2, Georgina gidgee woodlands. We are grateful to the original authors and teams whose work it builds on:

Yong Liam and TERN support (Research Data Services) for providing the original Kepler workflow files and for guidance.
All raw data files were accessed through the CoESRA Virtual Desktop. Workflow description on TERN webpage were very helpful.
The Desert Ecology Research Group, University of Sydney, and the authors of Wardle, Greenville, Frank, Tischler, Emery & Dickman (2015), Austral Ecology 40(4), https://doi.org/10.1111/aec.12265, whose ecosystem risk assessment set the direction.

We adopted the original workflow’s components, logic, functions and parameters, and re-implemented them in R. Any errors are ours.

## Run Workflow:
1. copy the repository link
2. open a new project with git version history
3. choose local file path as you please
4. copy the repository
5. open the `.qmd` file
6. Click render option and get a cuppa, it will take 6-12 mins
7. `html` file will be opened automaticlaly in your default browser.

 Workflow Steps taken to re-design:

Species: 
1. Georgina gidgee (Acacia georginae F.M.Bailey) occurrences from GBIF on 13-Aug-2026-02:38:46.080849
2. CSV Data from TERN

Study Area: 
IBRA 7 selected areas
BRT	Burt Plain	MGD	Mitchell Grass Downs
CHC	Channel Country	MII	Mount Isa Inlier.
DEU	Desert Uplands	MUL	Mulga Lands
DMR	Davenport Murchison Ranges	SSD	Simpson Strzelecki Dunefields
FIN	Finke	STP	Stony Plains
GSD	Great Sandy Desert	TAN	Tanami
MAC	MacDonnell Ranges		

Map of known locations of Georgina gidgee woodlands overlain on the 89 biogregions of the Interim Biogeographic Regionalisation for Australia (IBRA 7) (Department of Environment, 2012). Records of occurrence obtained from the Atlas of Living Australia (www.ala.org.au/ accessed 22 March 2014).

Current raster Stack:
Baseline: Baseline/2000/ — bioclim_01–19, ibra, soil (2.5 arcmin)

Algorithm:
MaxEnt

Future raster Stack:
CMIP3/SRES: A1B/CSIRO_mk3.6/2.5_arcmin/{2030,2050,2070}
CMIP5/AR5: AR5/CSIRO_mk3.6/2.5_arcmin/{RCP26,RCP45,RCP60,RCP85}/{2030,2050,2070,2080}

Re-reunning this workflow
- clone the repository
- unzip the data folder(path should match otherwise if facing error check paths)
- Run Component 1 SDM

Findings:
- Criterion C: matches the original Kepler (VU).
- B cut-offs: the script’s cut-offs match the original XML exactly: EOO 2,000 / 20,000 / 50,000 km² and AOO 2 / 20 / 50 cells.
- Overall: the published result is Vulnerable (C2b, D1, D2a). Yours is VU driven by C only, because D isn’t evaluated.
-  Drop test, 2050: A1B −44.3%, RCP26 −45.7%, RCP45 −13.5%, RCP60 −15.2% and RCP85 −44.3%. So 3 of 5 declines are at least 30%, and all are inside the published 7–95% range.
- The “eight scenarios” count: I misread the paper’s abstract earlier. It says “at least 30% in eight scenarios” with 7–95% across all scenarios, so eight is a subset of a larger set. One GCM gives 5 scenarios at 2050.

Comparison from previous Study:
B (EOO and AOO)
Same: the same convex-hull and grid method, and the cut-offs match the original XML exactly (EOO 2,000 / 20,000 / 50,000 km²; AOO 2 / 20 / 50 cells).
Changed (AOO): the 2026 version counts distinct occupied cells; the original looks like it counted points.
Changed (B3): B3 locations is now NA, since the inputs have no threat data.
Scoring: B is now scored from the calculated values, giving LC (EOO 658,660 km², AOO 272 cells). Before, the earlier tes.R hard-coded LC. The original’s B score isn’t stored in the XML, so there is nothing to compare it with.

C (SDM)
Same: the SDM was fitted on the baseline and projected to the A1B and AR5 scenarios.
Changed (scoring): the original typed the C scores in (1, 4, 0). Now C is scored from the computed decline in suitable area at 2050 (VU at 30% or more, EN at 50%, CR at 80%), taking the worst scenario. The result is VU (declines 13.5–45.7%).



## Fair Check
<!-- FAIR:START -->
<!-- FAIR:END -->
