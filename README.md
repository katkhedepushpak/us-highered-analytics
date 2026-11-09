# Higher-Ed Outcomes Analytics (dbt + DuckDB + Power BI)

A small end-to-end analytics engineering project: integrate two public U.S. Department of
Education sources, model them into a tested star schema with dbt, and report on them in Power BI.

**Question answered:** how do Oregon institutions compare with peers on graduation, retention,
cost, earnings and enrollment?

> Personal project, built to practice analytics engineering. Data is public and real (not synthetic).

## Sources
| Source | Use |
|---|---|
| College Scorecard, institution-level (June 2026 release) | Outcomes, cost, earnings |
| IPEDS HD 2024 | Institution characteristics, location |
| IPEDS EF 2023 (fall enrollment) | Enrollment by student level |
| IPEDS GR 2023 (graduation rates) | Bachelor's cohort completion |

All join on `UNITID`.

## Architecture (medallion)
```
raw CSVs -> bronze (views, all text) -> silver (typed, one row per institution) -> gold (star schema) -> exports/*.csv -> Power BI
```
- **Bronze:** raw files read as text, nothing coerced.
- **Silver:** typing, cleaning of `NULL`/`PrivacySuppressed`, and long-to-wide collapse of IPEDS files to one row per institution.
- **Gold:** `fact_institution_outcomes` + `dim_institution`, `dim_control`, `dim_region`.

## Data quality
25 dbt data tests run on every build: uniqueness and not-null keys, relationships between fact and
dimensions, a custom 0-1 range test on rates, and a cross-source reconciliation (IPEDS-computed vs
Scorecard graduation rate: correlation 0.965, median gap 2.3 points across 1,713 institutions; the
31 institutions above a 15-point gap are small colleges with volatile cohorts and surface as a warning).

## Run it
```bash
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install dbt-duckdb
# download the four source files into raw/ (see WALKTHROUGH.md for URLs)
mkdir exports
dbt build --profiles-dir .
dbt docs generate --profiles-dir . && dbt docs serve --profiles-dir .
```
Gold tables export to `exports/` for Power BI.

## Known limitations
- GRTYPE codes (2 = bachelor's cohort, 3 = completers in 150%) were inferred, then validated against Scorecard; no official codebook was used.
- Scorecard and IPEDS cover slightly different cohort years.
- No incremental models or slowly changing dimensions: the data is a single snapshot, so they would not be meaningful.
