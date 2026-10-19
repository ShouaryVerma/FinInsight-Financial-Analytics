
-- FININSIGHT PROJECT
-- 01: CREATE DATABASE TABLES

-- Table 1: Account Dimension
CREATE TABLE IF NOT EXISTS public.dimaccounts (
    "Account" TEXT,
    "Line Item" TEXT,
    "Group" TEXT,
    "Sub Class" TEXT,
    "Class" TEXT
);

-- Table 2: Geography Dimension
CREATE TABLE IF NOT EXISTS public.dimexecgeography (
    "Profit Center" TEXT,
    "Profit Center SEC Func Area" TEXT,
    "Cost Per Head PC Flag" TEXT,
    "Exec Function Summary" TEXT,
    "Exec Org Detail" TEXT,
    "Exec Org" TEXT,
    "WW Area" TEXT,
    "WW Region" TEXT,
    "Area Summary" TEXT
);

-- Table 3: FactFinanceData
-- 
CREATE TABLE public.factfinancedata (
    "Fiscal Month" TEXT,
    "Profit Center" TEXT,
    "Account" TEXT,
    "Forecast Version" TEXT,
    "YTD Flag" TEXT,
    "Actual" NUMERIC(20,4),
    "Budget" NUMERIC(20,4),
    "Forecast" NUMERIC(20,4),
    "Actual People" NUMERIC(20,4),
    "Budget Position" NUMERIC(20,4),
    "Forecast People" NUMERIC(20,4)
);

