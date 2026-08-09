import sqlite3

conn = sqlite3.connect("ecommerce.db")
c = conn.cursor()
c.execute("SELECT name FROM sqlite_master WHERE type='table'")
print("tables:", [r[0] for r in c.fetchall()])
conn.close()
