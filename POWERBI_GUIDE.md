# Power BI build guide (Windows, ~35 min)

## 1. Load (5 min)
Home > Get data > Text/CSV. Load all four from `exports/`:
`fact_institution_outcomes`, `dim_institution`, `dim_control`, `dim_region`.
Check column types in Power Query: rates = Decimal, `unitid`/codes = Whole number. Close & Apply.

## 2. Model (5 min), Model view
Create these relationships (drag field to field), all one-to-many, single direction (dimension filters fact):
- `dim_institution[unitid]` -> `fact_institution_outcomes[unitid]` (1:1 is fine here; keep dimension as the "one")
- `dim_control[control_code]` -> `dim_institution[control_code]`
- `dim_region[region_code]` -> `dim_institution[region_code]`

Mark `dim_institution[latitude]` Data category = Latitude, `[longitude]` = Longitude.

## 3. Measures (10 min), New measure
```
Institutions = DISTINCTCOUNT(fact_institution_outcomes[unitid])
Avg Grad Rate = AVERAGE(fact_institution_outcomes[grad_rate_150_sc])
Avg Retention = AVERAGE(fact_institution_outcomes[retention_rate_ft])
Avg Net Price = AVERAGE(fact_institution_outcomes[avg_net_price])
Median Earnings 10yr = MEDIAN(fact_institution_outcomes[median_earnings_10yr])
Grad Rate National = CALCULATE([Avg Grad Rate], ALL(dim_institution))
Grad Rate Gap vs National = [Avg Grad Rate] - [Grad Rate National]
```
`ALL(dim_institution)` removes filters from the dimension, which gives the national baseline
regardless of the state or region you filter to. That is the core of the "Oregon vs national" story.

Format rates as percentages, prices and earnings as currency.

## 4. Report page (15 min)
Page-level filter: `dim_institution[predominant_degree]` = Bachelor's (grad-rate data only applies to 4-year schools).
- Slicers: `control_type`, `region_name`, `is_oregon`.
- Cards: Institutions, Avg Grad Rate, Grad Rate Gap vs National, Median Earnings 10yr.
- Clustered bar: Avg Grad Rate by `region_name`.
- Scatter: x = Avg Net Price, y = Median Earnings 10yr, details = institution_name, size = total_enrollment.
- Map: latitude/longitude, bubble size = total_enrollment, color = Avg Grad Rate.
- Table: Oregon institutions (is_oregon = TRUE) with grad rate, retention, net price, earnings.
- Text box: 3 insights you actually see in the data. Write them yourself after exploring.

## 5. Row-level security (5 min, optional)
Modeling > Manage roles > New role "Far West" > table `dim_region`, filter
`[region_name] = "Far West"`. Test with View as. Mention it only if you complete it.

## 6. Save and screenshot
Save as `higher-ed-outcomes.pbix` in the repo root; export page 1 as PNG into `docs/`.
