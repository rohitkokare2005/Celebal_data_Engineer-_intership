# Apex Retail Intelligence — End-to-End Data Engineering Pipeline

**Celebal Technologies | CEI'26 Internship Programme — Major Project**

An end-to-end batch data pipeline built on Databricks using PySpark, Delta Lake,
and Unity Catalog, implementing the Medallion Architecture (Bronze → Silver → Gold)
to turn raw, messy retail CSV data into a business-ready Star Schema and KPI reporting.

## Architecture

```
Raw CSV (string-typed)
    │
    ▼
Landing (Parquet + audit PASS/FAIL validation)
    │
    ▼
Bronze (Delta Lake, ingested_at metadata, historical + incremental)
    │
    ▼
Silver (DQ rules, Delta MERGE, SCD Type 1/2, surrogate keys)
    │
    ▼
Gold (Star Schema, Unity Catalog registration)
    │
    ▼
KPI Reporting (5 business KPIs, inline in-notebook)
```

## Notebooks

| Notebook | Purpose |
|---|---|
| `01_raw_and_landing.ipynb` | CSV ingestion (string-typed), raw/ directory organization, Parquet conversion, dynamic audit file validation with PASS/FAIL reporting |
| `02_bronze_layer.ipynb` | Landing Parquet -> Delta Lake, `ingested_at` metadata injection, historical (overwrite) + incremental (append) loading |
| `03_silver_layer.ipynb` | Data quality rules, Delta MERGE (no watermarking), SCD Type 2 for customers, SCD Type 1 for products, immutable sales ledger, surrogate key generation |
| `gold_layer.ipynb` | Star Schema construction (dim_customer, dim_product, dim_promotion, dim_date, fact_sales), Unity Catalog registration under `GOLD_tables` |
| `05_kpi_reporting.ipynb` | 5 business KPIs computed via PySpark/Spark SQL, rendered inline -- no external dashboards |

## Key design decisions

- **SCD Type 2 (Customer)**: implemented as two sequential Delta MERGE passes -- one to expire changed active rows (`is_active = false`, `effective_end_date` stamped), one to insert the new active version.
- **SCD Type 1 (Product)**: single MERGE with `whenMatchedUpdateAll()` / `whenNotMatchedInsertAll()` -- overwrite in place, no history retained.
- **Sales (Immutable Ledger)**: pre-deduplicated via window function before merging, ensuring re-ingestion never creates duplicate transactions.
- **Surrogate keys** (`customer_sk`, `product_sk`, `sales_sk`): sequential, generated per Silver table, used for all Gold-layer joins.
- **Idempotency**: every layer is safe to re-run -- Landing/Bronze historical loads use `overwrite`, Bronze incremental uses `append` (by design, per spec), and all Silver/Gold operations use Delta `MERGE`.

## KPIs delivered

1. **Net Margin by Region** -- gross revenue minus discounts, by store region
2. **Average Order Value (AOV) by Promotion** -- average cart value per promotion type
3. **Demographic Churn Heatmap** -- churn rate by state x loyalty program
4. **Product Quality Index** -- return rate by product category
5. **Store Traffic by Hour** -- transaction volume by hour and day of week

## How to run

1. Import each `.ipynb` into a Databricks workspace with Unity Catalog enabled
2. Update the widget values at the top of each notebook (volume paths, catalog/schema names) to match your environment
3. Run in order: `01_raw_and_landing` -> `02_bronze_layer` (once as `historical`, once as `incremental`) -> `03_silver_layer` -> `gold_layer` -> `05_kpi_reporting`

## Tech stack

Apache Spark (PySpark) - Databricks - Delta Lake - Unity Catalog

---
*Individual submission for Celebal Technologies' CEI'26 Internship Programme.*
