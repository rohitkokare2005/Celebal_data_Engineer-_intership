import sqlite3
import pandas as pd

conn = sqlite3.connect("ecommerce.db")

# Original query from the notebook
query = '''
WITH item_pairs AS (
    SELECT
        oi1.order_id,
        CASE
            WHEN oi1.product_id < oi2.product_id
            THEN oi1.product_id
            ELSE oi2.product_id
        END AS product_a,
        CASE
            WHEN oi1.product_id < oi2.product_id
            THEN oi2.product_id
            ELSE oi1.product_id
        END AS product_b
    FROM order_items oi1
    JOIN order_items oi2
        ON oi1.order_id = oi2.order_id
       AND oi1.product_id < oi2.product_id
),
pair_counts AS (
    SELECT
        product_a,
        product_b,
        COUNT(DISTINCT order_id) AS times_bought_together
    FROM item_pairs
    GROUP BY product_a, product_b
)
SELECT
    pc.product_a,
    pa.product_name AS product_a_name,
    pc.product_b,
    pb.product_name AS product_b_name,
    pc.times_bought_together
FROM pair_counts pc
JOIN products pa ON pc.product_a = pa.product_id
JOIN products pb ON pc.product_b = pb.product_id
ORDER BY pc.times_bought_together DESC;
'''

try:
    df = pd.read_sql_query(query, conn)
    print("ORIGINAL QUERY SUCCEEDED")
    print("rows:", len(df))
    print(df.head(10))
except Exception as e:
    print("ORIGINAL QUERY FAILED:", e)

# Check string comparison edge case
cur = conn.cursor()
cur.execute("SELECT product_id FROM products")
ids = [r[0] for r in cur.fetchall()]
print("max id:", max(ids), "min id:", min(ids))
# PROD0100 vs PROD0099 lexicographic
print("'PROD0100' < 'PROD0099' lexicographically:", "PROD0100" < "PROD0099")

conn.close()
