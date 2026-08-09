import sqlite3

conn = sqlite3.connect("ecommerce.db")
c = conn.cursor()

# Check product_id ordering characteristics
c.execute("SELECT product_id FROM products WHERE product_id < 'PROD0100'")
rows = c.fetchall()
print("products lexicographically < 'PROD0100':", len(rows))
print([r[0] for r in rows[:20]])

c.execute("SELECT product_id FROM products")
all_ids = [r[0] for r in c.fetchall()]
print("total products:", len(all_ids))
print("max product_id:", max(all_ids))
print("min product_id:", min(all_ids))

# Check order_items product_id types
c.execute("SELECT product_id FROM order_items LIMIT 5")
print("order_items product_id samples:", c.fetchall())

conn.close()
