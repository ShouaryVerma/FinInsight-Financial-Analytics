
-- FININSIGHT PROJECT
-- 02: DATA VALIDATION

-- Verify Account records
SELECT
    COUNT(*) AS total_accounts,
    COUNT(DISTINCT "Account") AS unique_accounts
FROM public.dimaccounts;

-- Verify Geography records
SELECT
    COUNT(*) AS total_profit_centers,
    COUNT(DISTINCT "Profit Center") AS unique_profit_centers
FROM public.dimexecgeography;

-------------------------------------------
SELECT
    'DimAccounts' AS table_name,
    COUNT(*) AS total_rows
FROM public.dimaccounts

UNION ALL

SELECT
    'DimExecGeography',
    COUNT(*)
FROM public.dimexecgeography

UNION ALL

SELECT
    'FactFinanceData',
    COUNT(*)
FROM public.factfinancedata;

--------------------------------------------
SELECT
    "Fiscal Month",
    "Profit Center",
    "Account",
    "Forecast Version",
    "YTD Flag",
    "Actual",
    "Budget",
    "Forecast"
FROM public.factfinancedata
LIMIT 10;
---------------------------------------------

SELECT
    'DimAccounts' AS table_name,
    COUNT(*) - COUNT(DISTINCT "Account") AS duplicate_keys
FROM public.dimaccounts

UNION ALL

SELECT
    'DimExecGeography',
    COUNT(*) - COUNT(DISTINCT "Profit Center")
FROM public.dimexecgeography;
-------------------------------------------------


-- FININSIGHT: TABLE RELATIONSHIP VALIDATION

SELECT
    COUNT(*) AS total_joined_rows,

    COUNT(*) FILTER (
        WHERE a."Account" IS NULL
    ) AS unmatched_accounts,

    COUNT(*) FILTER (
        WHERE g."Profit Center" IS NULL
    ) AS unmatched_profit_centers

FROM public.factfinancedata AS f

LEFT JOIN public.dimaccounts AS a
    ON f."Account" = a."Account"

LEFT JOIN public.dimexecgeography AS g
    ON f."Profit Center" = g."Profit Center";



