# E-Commerce Order Analytics System

**Intern Mini Project — Week 8**
Duration: 3-4 weeks | Skills: Python, SQL, Problem Solving

A local Python + SQLite pipeline that generates realistic messy e-commerce
order data, cleans it, analyzes it with 16 SQL queries (basic through
advanced window functions/CTEs), exposes a command-line reporting tool,
and verifies correctness with edge-case tests.

## Project structure

```
.
├── generate_data.ipynb           # Part 1 — Data Generation
├── data_cleaning.ipynb           # Part 2 — Data Cleaning
├── sql_analysis.ipynb            # Part 3 — SQL Analysis (16 queries)
├── python_sql_integration.ipynb  # Part 4 — CLI reporting tool
├── edge_cases_tests.ipynb        # Part 5 — Edge case tests
├── data/
│   ├── customers.csv / cleaned_customers.csv
│   ├── products.csv  / cleaned_products.csv
│   ├── orders.csv    / cleaned_orders.csv
│   └── order_items.csv / cleaned_order_items.csv
├── reports/
│   └── data_quality_report.txt
└── ecommerce.db                  # SQLite database (cleaned data loaded)
```

## How to run (in order)

```bash
pip install pandas
jupyter notebook generate_data.ipynb            # Part 1: creates data/*.csv
jupyter notebook data_cleaning.ipynb             # Part 2: creates data/cleaned_*.csv + reports/data_quality_report.txt
jupyter notebook sql_analysis.ipynb              # Part 3: loads cleaned CSVs into ecommerce.db, runs all 16 queries
jupyter notebook python_sql_integration.ipynb    # Part 4: CLI summary report tool
jupyter notebook edge_cases_tests.ipynb          # Part 5: edge case test suite
```

## Part 1 — Data Generation

Generates 4 CSVs (500 customers, 100 products, 1000 orders, 2500 order_items)
with intentional data-quality issues:

| Issue | Rate |
|---|---|
| Missing `customer_id` in orders | ~5% |
| Negative `quantity` in order_items (returns) | ~3% |
| Wrong `order_date` format (DD-MM-YYYY) | some rows |
| Mangled `product_name` (spaces/case) | ~10% |
| Invalid emails (missing `@`/domain) | ~2% |

**Referential integrity by design**: `order_items.order_id` is always sampled
from the order IDs already generated for `orders.csv`, so every order_item
references a real order.

## Part 2 — Data Cleaning

Four required functions:

| Function | What it does |
|---|---|
| `clean_orders()` | Fixes date formats, handles NULL customer_ids |
| `clean_products()` | Normalizes product names (trim + title case) |
| `validate_emails()` | Returns customer_ids with invalid emails |
| `check_referential_integrity()` | Finds order_items referencing non-existent orders |

Output: 4 cleaned CSVs + `reports/data_quality_report.txt` summarizing every issue found.

## Part 3 — SQL Analysis

All 16 required queries against `ecommerce.db`, grouped as:
- **Basic (3)**: revenue per category, top 10 customers, month-wise order count
- **Intermediate (3)**: never-delivered customers, high-return products, return rate per category
- **Advanced (10)**: running totals, DENSE_RANK, LAG/LEAD "at risk" flagging, multi-level CTEs, NTILE quartiles, YoY comparison, first/last value category shift, cumulative revenue distribution, cohort retention analysis, self-join frequently-bought-together

> **Known issue**: a stray reconnect cell in `sql_analysis.ipynb` points at an
> empty placeholder file (`your_database.db`) instead of `ecommerce.db`,
> breaking the final self-join query. Fix: change that cell's connection
> string back to `sqlite3.connect("ecommerce.db")` (or delete the cell —
> the original connection from earlier in the notebook is already valid).

## Part 4 — Python + SQL Integration

`python_sql_integration.ipynb` implements a command-line report tool using
**only** the `sqlite3` standard library module (no pandas) that:
1. Takes report type (daily/weekly/monthly) and a date range
2. Queries `ecommerce.db` for total orders, revenue, unique customers
3. Shows top 3 products by revenue
4. Compares against the immediately preceding period of equal length, with % change

## Part 5 — Edge Case Handling

Five test functions (4 required + 1 bonus), all passing:
1. `order_items` referencing a non-existent `order_id` → detected via referential integrity check
2. `discount_percent > 100` → flagged invalid
3. `quantity = 0` → correctly contributes zero revenue, not misclassified as a return
4. `order_date` in the future → detectable via simple date filter
5. (bonus) Frequently-bought-together pair counting logic verified against a small known dataset

## Design notes

- **Revenue formula**, used consistently everywhere: `quantity * unit_price * (1 - discount_percent/100)`
- **Return rate** (Query 8) is quantity-weighted, not row-count-based
- **CLI "previous period"** is an equal-length window immediately preceding the requested range, generalizing across daily/weekly/monthly without hardcoding calendar boundaries
