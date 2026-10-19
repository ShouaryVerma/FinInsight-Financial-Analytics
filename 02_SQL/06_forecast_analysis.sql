
-- FININSIGHT PROJECT
-- 06: FORECAST ANALYSIS
-- Check forecast data by month and reporting status

SELECT
    f."Fiscal Month" AS fiscal_month,
    f."Forecast Version" AS forecast_version,
    f."YTD Flag" AS reporting_status,

    COUNT(*) AS total_records,

    COUNT(*) FILTER (
        WHERE f."Actual" IS NOT NULL
    ) AS actual_value_rows,

    COUNT(*) FILTER (
        WHERE f."Forecast" IS NOT NULL
    ) AS forecast_value_rows,

    ROUND(
        SUM(f."Actual") / 1000000, 2
    ) AS actual_m,

    ROUND(
        SUM(f."Forecast") / 1000000, 2
    ) AS forecast_m

FROM public.factfinancedata AS f

INNER JOIN public.dimaccounts AS a
    ON f."Account" = a."Account"

WHERE a."Class" = 'Expenses'
  AND f."Fiscal Month" IN (
      'July, 2012',
      'August, 2012',
      'September, 2012',
      'October, 2012',
      'November, 2012',
      'December, 2012'
  )

GROUP BY
    f."Fiscal Month",
    f."Forecast Version",
    f."YTD Flag"

ORDER BY
    TO_DATE(f."Fiscal Month", 'FMMonth, YYYY'),
    f."Forecast Version",
    f."YTD Flag";

--------------------------------------------------------------


-- FININSIGHT PROJECT
-- 06: FORECAST ANALYSIS
-- Compare actual and forecast scenarios by month

SELECT
    f."Fiscal Month" AS fiscal_month,
    f."YTD Flag" AS reporting_status,

    COUNT(*) FILTER (
        WHERE f."Forecast Version" = 'N/A'
    ) AS actual_scenario_rows,

    COUNT(*) FILTER (
        WHERE f."Forecast Version" = 'October Forecast'
    ) AS forecast_scenario_rows,

    ROUND(
        SUM(f."Actual") FILTER (
            WHERE f."Forecast Version" = 'N/A'
        ) / 1000000, 2
    ) AS actual_expenses_m,

    ROUND(
        SUM(f."Forecast") FILTER (
            WHERE f."Forecast Version" = 'October Forecast'
        ) / 1000000, 2
    ) AS forecast_expenses_m

FROM public.factfinancedata AS f

JOIN public.dimaccounts AS a
    ON f."Account" = a."Account"

WHERE a."Class" = 'Expenses'
  AND f."Fiscal Month" IN (
      'July, 2012',
      'August, 2012',
      'September, 2012',
      'October, 2012',
      'November, 2012',
      'December, 2012'
  )

GROUP BY
    f."Fiscal Month",
    f."YTD Flag"

ORDER BY
    TO_DATE(f."Fiscal Month", 'FMMonth, YYYY'),
    f."YTD Flag";

------------------------------------------------------------------


-- FININSIGHT PROJECT
-- 06: FORECAST ANALYSIS
-- Monthly Actual vs Forecast Variance

WITH monthly_forecast AS (
    SELECT
        f."Fiscal Month" AS fiscal_month,
        f."YTD Flag" AS reporting_status,

        SUM(f."Actual") FILTER (
            WHERE f."Forecast Version" = 'N/A'
        ) AS actual_expenses,

        SUM(f."Forecast") FILTER (
            WHERE f."Forecast Version" = 'October Forecast'
        ) AS forecast_expenses

    FROM public.factfinancedata AS f

    INNER JOIN public.dimaccounts AS a
        ON f."Account" = a."Account"

    WHERE a."Class" = 'Expenses'
      AND f."Fiscal Month" IN (
          'July, 2012',
          'August, 2012',
          'September, 2012',
          'October, 2012',
          'November, 2012',
          'December, 2012'
      )

    GROUP BY
        f."Fiscal Month",
        f."YTD Flag"
)

SELECT
    fiscal_month,
    reporting_status,

    ROUND(actual_expenses / 1000000, 2)
        AS actual_m,

    ROUND(forecast_expenses / 1000000, 2)
        AS forecast_m,

    ROUND(
        (actual_expenses - forecast_expenses)
        / 1000000, 2
    ) AS variance_m,

    ROUND(
        (actual_expenses - forecast_expenses)
        * 100.0 / NULLIF(ABS(forecast_expenses), 0),
        2
    ) AS variance_pct

FROM monthly_forecast

WHERE actual_expenses IS NOT NULL
  AND forecast_expenses IS NOT NULL

ORDER BY
    TO_DATE(fiscal_month, 'FMMonth, YYYY'),
    reporting_status;

--------------------------------------------------------------


-- Check actual and forecast record coverage

SELECT
    f."Fiscal Month" AS fiscal_month,

    COUNT(*) FILTER (
        WHERE f."Forecast Version" = 'N/A'
    ) AS actual_scenario_rows,

    COUNT(*) FILTER (
        WHERE f."Forecast Version" = 'October Forecast'
    ) AS forecast_scenario_rows,

    COUNT(*) FILTER (
        WHERE f."Forecast Version" = 'N/A'
          AND f."Actual" IS NOT NULL
          AND f."Actual" <> 0
    ) AS nonzero_actual_rows

FROM public.factfinancedata AS f

JOIN public.dimaccounts AS a
    ON f."Account" = a."Account"

WHERE a."Class" = 'Expenses'
  AND f."YTD Flag" = 'YTD'
  AND f."Fiscal Month" IN (
      'July, 2012',
      'August, 2012',
      'September, 2012',
      'October, 2012',
      'November, 2012',
      'December, 2012'
  )

GROUP BY f."Fiscal Month"

ORDER BY
    TO_DATE(f."Fiscal Month", 'FMMonth, YYYY');

-------------------------------------------------------------------


-- FININSIGHT PROJECT
-- Check matching Actual and Forecast records

WITH scenario_keys AS (
    SELECT
        f."Fiscal Month" AS fiscal_month,
        f."Account",
        f."Profit Center",

        MAX(CASE
            WHEN f."Forecast Version" = 'N/A'
            THEN 1 ELSE 0
        END) AS has_actual,

        MAX(CASE
            WHEN f."Forecast Version" = 'October Forecast'
            THEN 1 ELSE 0
        END) AS has_forecast

    FROM public.factfinancedata AS f

    JOIN public.dimaccounts AS a
        ON f."Account" = a."Account"

    WHERE a."Class" = 'Expenses'
      AND f."YTD Flag" = 'YTD'
      AND f."Forecast Version" IN (
          'N/A', 'October Forecast'
      )
      AND f."Fiscal Month" IN (
          'July, 2012',
          'August, 2012',
          'September, 2012',
          'October, 2012',
          'November, 2012',
          'December, 2012'
      )

    GROUP BY
        f."Fiscal Month",
        f."Account",
        f."Profit Center"
)

SELECT
    fiscal_month,

    COUNT(*) FILTER (
        WHERE has_actual = 1
    ) AS actual_keys,

    COUNT(*) FILTER (
        WHERE has_forecast = 1
    ) AS forecast_keys,

    COUNT(*) FILTER (
        WHERE has_actual = 1
          AND has_forecast = 1
    ) AS matching_keys

FROM scenario_keys

GROUP BY fiscal_month

ORDER BY
    TO_DATE(fiscal_month, 'FMMonth, YYYY');

-- FININSIGHT PROJECT
-- Check matching Actual and Forecast records

WITH scenario_keys AS (
    SELECT
        f."Fiscal Month" AS fiscal_month,
        f."Account",
        f."Profit Center",

        MAX(CASE
            WHEN f."Forecast Version" = 'N/A'
            THEN 1 ELSE 0
        END) AS has_actual,

        MAX(CASE
            WHEN f."Forecast Version" = 'October Forecast'
            THEN 1 ELSE 0
        END) AS has_forecast

    FROM public.factfinancedata AS f

    JOIN public.dimaccounts AS a
        ON f."Account" = a."Account"

    WHERE a."Class" = 'Expenses'
      AND f."YTD Flag" = 'YTD'
      AND f."Forecast Version" IN (
          'N/A', 'October Forecast'
      )
      AND f."Fiscal Month" IN (
          'July, 2012',
          'August, 2012',
          'September, 2012',
          'October, 2012',
          'November, 2012',
          'December, 2012'
      )

    GROUP BY
        f."Fiscal Month",
        f."Account",
        f."Profit Center"
)

SELECT
    fiscal_month,

    COUNT(*) FILTER (
        WHERE has_actual = 1
    ) AS actual_keys,

    COUNT(*) FILTER (
        WHERE has_forecast = 1
    ) AS forecast_keys,

    COUNT(*) FILTER (
        WHERE has_actual = 1
          AND has_forecast = 1
    ) AS matching_keys

FROM scenario_keys

GROUP BY fiscal_month

ORDER BY
    TO_DATE(fiscal_month, 'FMMonth, YYYY');

-----------------------------------------------------------------------


-- Forecast Variance by Expense Category

SELECT
    a."Group" AS expense_category,

    ROUND(
        (SUM(f."Actual") FILTER (
            WHERE f."Forecast Version" = 'N/A'
        )) / 1000000, 2
    ) AS actual_m,

    ROUND(
        (SUM(f."Forecast") FILTER (
            WHERE f."Forecast Version" = 'October Forecast'
        )) / 1000000, 2
    ) AS forecast_m,

    ROUND(
        (
            SUM(f."Actual") FILTER (
                WHERE f."Forecast Version" = 'N/A'
            )
            -
            SUM(f."Forecast") FILTER (
                WHERE f."Forecast Version" = 'October Forecast'
            )
        ) / 1000000, 2
    ) AS variance_m

FROM public.factfinancedata AS f

JOIN public.dimaccounts AS a
    ON f."Account" = a."Account"

WHERE a."Class" = 'Expenses'
  AND f."YTD Flag" = 'YTD'
  AND f."Fiscal Month" IN (
      'July, 2012',
      'August, 2012',
      'September, 2012',
      'October, 2012',
      'November, 2012',
      'December, 2012'
  )
  AND f."Forecast Version" IN (
      'N/A',
      'October Forecast'
  )

GROUP BY a."Group"

HAVING COUNT(*) FILTER (
    WHERE f."Forecast Version" = 'N/A'
) > 0
AND COUNT(*) FILTER (
    WHERE f."Forecast Version" = 'October Forecast'
) > 0

ORDER BY ABS(
    COALESCE(
        SUM(f."Actual") FILTER (
            WHERE f."Forecast Version" = 'N/A'
        ), 0
    ) -
    COALESCE(
        SUM(f."Forecast") FILTER (
            WHERE f."Forecast Version" = 'October Forecast'
        ), 0
    )
) DESC

LIMIT 5;



