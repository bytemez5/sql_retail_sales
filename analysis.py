import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="p1_retail_db",
    user="your_username",
    password="your_password"
)

cursor = conn.cursor()

# Total sales by category
cursor.execute("""
    SELECT category, SUM(total_sale) AS total_revenue
    FROM retail_sales
    GROUP BY category
    ORDER BY total_revenue DESC;
""")

rows = cursor.fetchall()
for row in rows:
    print(row)

cursor.close()
conn.close()
