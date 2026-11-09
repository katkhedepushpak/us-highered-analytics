{% test between_0_and_1(model, column_name) %}
-- Custom generic test: a rate must fall between 0 and 1. Returns violating rows;
-- the test passes when no rows come back. NULLs are allowed (suppressed data).
select {{ column_name }}
from {{ model }}
where {{ column_name }} < 0 or {{ column_name }} > 1
{% endtest %}
