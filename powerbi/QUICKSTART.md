# Power BI quick start (about 20 minutes)

Files in this folder: `load_tables.m` (Power Query), `measures.dax` (DAX). Not yet tested in Power BI Desktop; if something fails, the error message names the step.

## 0. Get the data onto the Windows machine (2 min)
Clone the repo (or download the ZIP from GitHub). You only need the `exports/` folder.

## 1. Load the tables (5 min)
1. Power BI Desktop > **Home > Transform data** (opens Power Query).
2. **New Source > Blank Query > Advanced Editor.** Paste Query 1 from `load_tables.m`, **edit the path**, name it `ExportsFolder`.
3. Repeat for Queries 2-5. Rename each query to the name in its header comment.
4. **Close & Apply.** You should see 4 tables with about 6,273 rows in the fact and `dim_institution`.

## 2. Relationships (3 min), Model view
Drag field to field. All "one to many", single direction:
- `dim_institution[unitid]` to `fact_institution_outcomes[unitid]` (Power BI may offer 1:1; accept it, direction single)
- `dim_control[control_code]` to `dim_institution[control_code]`
- `dim_region[region_code]` to `dim_institution[region_code]`

In `dim_institution`, select `latitude` and set **Data category = Latitude**, same for `longitude`.
Select the column `predominant_degree`, nothing else needed.

## 3. Measures (4 min)
Select `fact_institution_outcomes`, then **New measure** for each line in `measures.dax`.
Format: `Avg Grad Rate`, `Avg Retention`, `Grad Rate National`, `Grad Rate Gap vs National` as Percentage; `Avg Net Price`, `Median Earnings 10yr` as Currency.

## 4. The report page (8 min)
**Page filter** (Filters pane, "Filters on this page"): `dim_institution[predominant_degree]` = **Bachelor's** (grad-rate data only applies to 4-year schools).

| Visual | Fields |
|---|---|
| 3 Slicers | `dim_control[control_type]`, `dim_region[region_name]`, `dim_institution[is_oregon]` |
| 4 Cards | `Institutions`, `Avg Grad Rate`, `Grad Rate Gap vs National`, `Median Earnings 10yr` |
| Clustered bar | Axis: `dim_region[region_name]`; Values: `Avg Grad Rate` |
| Scatter | X: `Avg Net Price`; Y: `Median Earnings 10yr`; Details: `dim_institution[institution_name]`; Size: `fact_institution_outcomes[total_enrollment]` |
| Map | Latitude/Longitude from `dim_institution`; Size: `total_enrollment`; Color: `Avg Grad Rate` |
| Table | Filter `is_oregon` = true; columns: institution name, `Avg Grad Rate`, `Avg Retention`, `Avg Net Price`, `Median Earnings 10yr` |

Set the `is_oregon` slicer to **true** to see Oregon vs the national baseline on the cards.

### The tiles (cards) and what they should show
Page filter = Bachelor's. Values below were computed from the exported data; if yours differ, a relationship or filter is off.

| Tile | Measure | What it shows | Oregon (`is_oregon` = true) | No slicer (national) |
|---|---|---|---|---|
| Institutions | `Institutions` | How many colleges are in view | 26 | 1,947 |
| Graduation rate | `Avg Grad Rate` | Average 6-year (150%) graduation rate across institutions | 56.4% | 54.5% |
| Gap vs national | `Grad Rate Gap vs National` | Oregon rate minus the national baseline | +1.9 pts | 0.0 |
| Median earnings | `Median Earnings 10yr` | Median of institutions' median earnings 10 years after enrollment | $57,671 | $53,781 |

Optional extra tiles: `Avg Retention` (Oregon 80.1% vs 74.7%) and `Avg Net Price` (Oregon $24,204 vs $21,149).

Notes: rates are unweighted averages (each college counts equally, not by size). `Institutions` counts every college in view, but the rate averages skip colleges with no reported value.

## 5. Save
`higher-ed-outcomes.pbix`, then export page 1 as a PNG.

## Talk about it (what the model does)
- Star schema: one fact table, three dimensions.
- `Grad Rate National` uses `CALCULATE` + `ALL(dim_institution)`: the baseline ignores filters, so the gap card shows Oregon against the nation.
