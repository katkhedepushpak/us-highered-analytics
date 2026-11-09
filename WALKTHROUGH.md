# Walkthrough: read this before you talk about the project

## The story in 30 seconds
"I integrated College Scorecard and IPEDS data into a medallion-style dbt project. The hard part was
grain: the IPEDS files are long format, so I collapsed them to one row per institution before joining,
which keeps the fact table from fanning out. I tested keys, relationships and ranges on every build,
and reconciled two independent sources on graduation rate (correlation 0.965). Power BI sits on the
gold star schema."

## Key ideas, in plain words
- **Grain:** what one row means. Fact table = one row per institution. Joining a long table (many rows per institution) to it would multiply rows and double-count. We fixed that in silver.
- **Medallion layers:** bronze = raw and untouched (so you can always compare to the source); silver = cleaned and typed; gold = shaped for analysis.
- **`try_cast`:** converts text to numbers and returns NULL if it can't, so `PrivacySuppressed` becomes a real missing value instead of an error.
- **Star schema:** one fact table (numbers) + dimension tables (descriptions). Power BI is built for this.
- **dbt tests:** SQL that returns bad rows; zero rows = pass.
- **Warn vs fail:** the reconciliation test is a warning because small colleges legitimately differ; it flags rows to review, not a broken pipeline.
- **Post-hook export:** each gold model writes its own CSV, so the BI layer is decoupled from dbt.

## Decisions you should be able to defend
1. *Why all text in bronze?* No silent coercion; typing is an explicit, reviewable step in silver.
2. *Why collapse IPEDS in silver, not gold?* So the grain is guaranteed before anything joins; the unique test on `unitid` enforces it.
3. *Why were GRTYPE codes inferred?* No codebook was in the download. I derived them from Oregon State's rows, then validated across 1,713 institutions against Scorecard (corr 0.965).
4. *Why no SCD or incremental models?* One snapshot of data; they'd be decorative. Stated in the README.
5. *Why Scorecard as the spine of `dim_institution`?* It defines the institutions we report on; IPEDS only adds attributes (left join).

## Likely interview questions
- "What would you do if the fact table had duplicate keys?" -> check join grain, find the table with many rows per key, aggregate it first.
- "How do you know the numbers are right?" -> tests on every build plus the cross-source reconciliation; I can name the 31 outliers.
- "What would you change for production?" -> orchestration/scheduling, incremental loads, source freshness checks, an official codebook, CI running `dbt build` on pull requests.

## Source URLs
- Scorecard: https://ed-public-download.scorecard.network/downloads/Most-Recent-Cohorts-Institution_06102026.zip
- IPEDS: https://nces.ed.gov/ipeds/datacenter/data/HD2024.zip , EF2023A.zip , GR2023.zip
