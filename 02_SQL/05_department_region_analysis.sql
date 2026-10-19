
-- FININSIGHT PROJECT
-- 05: DEPARTMENT & REGIONAL ANALYSIS
-- Department-wise Expense Performance

SELECT
    g."Profit Center SEC Func Area" AS department,

    COUNT(*) AS total_records,

    ROUND(
        SUM(f."Actual") / 1000000, 2
    ) AS actual_expenses_m,

    ROUND(
        SUM(f."Budget") / 1000000, 2
    ) AS budget_m,

    ROUND(
        (SUM(f."Actual") - SUM(f."Budget"))
        / 1000000, 2
    ) AS variance_m,

    ROUND(
        SUM(f."Actual") * 100.0 /
        NULLIF(SUM(f."Budget"), 0), 2
    ) AS budget_utilization_pct

FROM public.factfinancedata AS f

INNER JOIN public.dimaccounts AS a
    ON f."Account" = a."Account"

INNER JOIN public.dimexecgeography AS g
    ON f."Profit Center" = g."Profit Center"

WHERE a."Class" = 'Expenses'
  AND f."Forecast Version" = 'N/A'
  AND f."YTD Flag" = 'YTD'
  AND f."Fiscal Month" IN (
      'July, 2012',
      'August, 2012',
      'September, 2012',
      'October, 2012',
      'November, 2012',
      'December, 2012'
  )

GROUP BY
    g."Profit Center SEC Func Area"

ORDER BY
    actual_expenses_m DESC;

-----------------------------------------------------


-- FININSIGHT PROJECT
-- 05: DEPARTMENT & REGIONAL ANALYSIS
-- Regional Expense Performance

SELECT
    g."WW Region" AS region,

    COUNT(*) AS total_records,

    ROUND(
        SUM(f."Actual") / 1000000, 2
    ) AS actual_expenses_m,

    ROUND(
        SUM(f."Budget") / 1000000, 2
    ) AS budget_m,

    ROUND(
        (SUM(f."Actual") - SUM(f."Budget"))
        / 1000000, 2
    ) AS variance_m,

    ROUND(
        SUM(f."Actual") * 100.0 /
        NULLIF(SUM(f."Budget"), 0), 2
    ) AS budget_utilization_pct

FROM public.factfinancedata AS f

INNER JOIN public.dimaccounts AS a
    ON f."Account" = a."Account"

INNER JOIN public.dimexecgeography AS g
    ON f."Profit Center" = g."Profit Center"

WHERE a."Class" = 'Expenses'
  AND f."Forecast Version" = 'N/A'
  AND f."YTD Flag" = 'YTD'
  AND f."Fiscal Month" IN (
      'July, 2012',
      'August, 2012',
      'September, 2012',
      'October, 2012',
      'November, 2012',
      'December, 2012'
  )

GROUP BY
    g."WW Region"

ORDER BY
    actual_expenses_m DESC;

