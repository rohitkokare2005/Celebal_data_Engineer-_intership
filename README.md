# Celebal Technologies — CEI'26 Internship Programme

**Data Engineering Track — Weekly Assignments Summary**

This repository documents the weekly assignments completed as part of the
CEI'26 Internship Programme's Data Engineering practice track, progressing
from foundational data manipulation (Pandas, SQL) through cloud data
pipelines (Azure ADF), distributed processing (Spark, Delta Lake), and
culminating in a full end-to-end analytics system.

## Assignment Overview

| Week | Assignment | Focus Area |
|---|---|---|
| 1 | Basic Data Exploration and Cleaning using Pandas | Data wrangling fundamentals |
| 2 | SQL-based Data Analysis | Filtering, aggregation, business queries |
| 3 | Subqueries, CTEs, and Window Functions | Superstore dataset sales analysis |
| 4 | Azure Cloud Fundamentals and Data Pipeline Implementation | ADF (Azure Data Factory) |
| 5 | Spark Questions | Apache Spark fundamentals |
| 6 | Spark Assignment | Applied Spark processing |
| 7 | Delta Lake MERGE Implementation | Delta Lake, upsert logic |
| 8 | E-Commerce Order Analytics System | Python + SQL, end-to-end mini project |

---

## Week 1 — Basic Data Exploration and Cleaning using Pandas
Introductory assignment covering core Pandas operations: loading datasets,
inspecting structure (`.info()`, `.describe()`), handling missing values,
identifying and correcting data quality issues, and basic data cleaning
workflows.

## Week 2 — SQL-based Data Analysis
Applied SQL fundamentals: `WHERE`/`HAVING` filtering, `GROUP BY` aggregation,
joins, and business-oriented queries (e.g., totals, counts, and summaries
answering practical questions about a dataset).

## Week 3 — Subqueries, CTEs, and Window Functions
Intermediate-to-advanced SQL applied to the Superstore sales dataset:
nested subqueries, Common Table Expressions (CTEs) for multi-step logic,
and window functions (ranking, running totals, partitioned aggregates) for
sales performance analysis.

## Week 4 — Azure Cloud Fundamentals and Data Pipeline Implementation
Introduction to cloud-based data engineering using Azure Data Factory (ADF):
pipeline design, data movement/transformation activities, and orchestration
fundamentals within the Azure ecosystem.

## Week 5 — Spark Questions
Conceptual and applied questions covering Apache Spark fundamentals —
distributed computing concepts, RDDs/DataFrames, transformations vs.
actions, and Spark's execution model.

## Week 6 — Spark Assignment
Hands-on Spark assignment applying distributed data processing techniques
to a practical dataset, building on the concepts introduced in Week 5.

## Week 7 — Delta Lake MERGE Implementation
Focused assignment on Delta Lake's `MERGE` operation — implementing upsert
logic (update matched records, insert new ones) as a foundation for the
incremental data processing patterns used later in the Major Project.

## Week 8 — E-Commerce Order Analytics System
A complete local Python + SQL mini-project (3-4 weeks), simulating a
messy multi-source e-commerce dataset and building a full pipeline to
clean, analyze, and report on it.

**Deliverables:**
- **Part 1 — Data Generation**: Python script generating 4 CSVs (customers,
  orders, order_items, products, 500+ rows each) with intentional data
  quality issues (missing customer_ids, invalid emails, wrong date formats,
  negative quantities, malformed product names), while preserving
  referential integrity by construction.
- **Part 2 — Data Cleaning**: `clean_orders()`, `clean_products()`,
  `validate_emails()`, `check_referential_integrity()` — plus a written
  data quality report of every issue found.
- **Part 3 — SQL Analysis**: 16 queries against a SQLite database, spanning
  basic aggregation, intermediate business logic, and advanced window
  functions / CTEs / self-joins (running totals, `DENSE_RANK`, LAG/LEAD
  "at risk" flagging, cohort retention analysis, NTILE segmentation,
  year-over-year comparison, and frequently-bought-together product pairs).
- **Part 4 — Python + SQL Integration**: a command-line reporting tool
  (stdlib `sqlite3` only) that generates daily/weekly/monthly summary
  reports with period-over-period % change comparisons.
- **Part 5 — Edge Case Handling**: test functions verifying behavior for
  invalid order references, out-of-range discounts, zero-quantity orders,
  and future-dated orders.

---

## Tech Stack Across the Programme

Python (Pandas) · SQL (SQLite) · Microsoft Azure (Data Factory) ·
Apache Spark (PySpark) · Delta Lake · Databricks · Unity Catalog

---
*Celebal Technologies — CEI'26 Internship Programme, Data Engineering Track.*
*Individual submissions per academic integrity guidelines.*
