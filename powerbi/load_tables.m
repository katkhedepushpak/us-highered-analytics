// ============================================================================
// Power BI load script. Create 5 queries in Power Query:
//   Home > Get data > Blank query > Advanced Editor, paste ONE block, rename the
//   query to the name in the header comment, then click Done.
// Do the ExportsFolder query FIRST; the other four read from it.
// ============================================================================


// ---------- Query 1. name it: ExportsFolder ----------
// Change the path to the exports folder on this machine. Keep the trailing backslash.
"C:\Users\YOURNAME\us-highered-analytics\exports\" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]


// ---------- Query 2. name it: dim_control ----------
let
    Source = Csv.Document(File.Contents(ExportsFolder & "dim_control.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(Promoted, {{"control_code", Int64.Type}, {"control_type", type text}}, "en-US")
in
    Typed


// ---------- Query 3. name it: dim_region ----------
let
    Source = Csv.Document(File.Contents(ExportsFolder & "dim_region.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(Promoted, {{"region_code", Int64.Type}, {"region_name", type text}}, "en-US")
in
    Typed


// ---------- Query 4. name it: dim_institution ----------
let
    Source = Csv.Document(File.Contents(ExportsFolder & "dim_institution.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(Promoted, {
        {"unitid", Int64.Type}, {"institution_name", type text}, {"city", type text},
        {"state_code", type text}, {"control_code", Int64.Type}, {"region_code", Int64.Type},
        {"predominant_degree_code", Int64.Type}, {"predominant_degree", type text},
        {"is_oregon", type logical}, {"latitude", type number}, {"longitude", type number}}, "en-US")
in
    Typed


// ---------- Query 5. name it: fact_institution_outcomes ----------
let
    Source = Csv.Document(File.Contents(ExportsFolder & "fact_institution_outcomes.csv"), [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(Promoted, {
        {"unitid", Int64.Type}, {"admission_rate", type number}, {"retention_rate_ft", type number},
        {"grad_rate_150_sc", type number}, {"grad_rate_150_ipeds", type number},
        {"bachelors_cohort", Int64.Type}, {"bachelors_completers_150", Int64.Type},
        {"avg_net_price", type number}, {"tuition_in_state", type number},
        {"tuition_out_of_state", type number}, {"pell_grant_share", type number},
        {"median_earnings_10yr", type number}, {"total_enrollment", Int64.Type},
        {"undergrad_enrollment", Int64.Type}, {"graduate_enrollment", Int64.Type}}, "en-US")
in
    Typed
