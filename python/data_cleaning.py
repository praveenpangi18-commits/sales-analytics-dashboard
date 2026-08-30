import pandas as pd

customers = pd.read_csv("../data/raw/customers.csv")
products = pd.read_csv("../data/raw/products.csv")
orders = pd.read_csv("../data/raw/orders.csv")
details = pd.read_csv("../data/raw/order_details.csv")

for df in [customers, products, orders, details]:
    df.drop_duplicates(inplace=True)

orders["order_date"] = pd.to_datetime(orders["order_date"])

sales = (details.merge(orders, on="order_id")
         .merge(products, on="product_id")
         .merge(customers, on="customer_id"))

sales["gross_sales"] = sales["quantity"] * sales["price"]
sales["discount_amount"] = sales["gross_sales"] * sales["discount"] / 100
sales["revenue"] = sales["gross_sales"] - sales["discount_amount"]
sales["cost_amount"] = sales["quantity"] * sales["cost"]
sales["profit"] = sales["revenue"] - sales["cost_amount"]

sales.to_csv("../data/cleaned/sales_cleaned.csv", index=False)
print("Cleaned dataset created successfully.")
print(sales.head())
