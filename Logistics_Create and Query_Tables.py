# Databricks notebook source
# MAGIC %md ## Author: Shiji  Copyright 02/06/2023

# COMMAND ----------

# MAGIC %md # Create SQL Tables...

# COMMAND ----------

# DBTITLE 1,Create Database
# MAGIC %sql
# MAGIC CREATE DATABASE IF NOT EXISTS lgproject

# COMMAND ----------

# MAGIC %sql
# MAGIC USE lgproject

# COMMAND ----------

# MAGIC %md
# MAGIC ### New Syntax requirement - must use absolute file path, need to add / to beginning of path.

# COMMAND ----------

# MAGIC %sql
# MAGIC DROP TABLE IF EXISTS product_sales;
# MAGIC
# MAGIC CREATE TABLE product_sales USING csv 
# MAGIC OPTIONS (path "/FileStore/tables/supply_chain_data-1.csv", header "true", inferSchema="true");
# MAGIC
# MAGIC SELECT * FROM product_sales limit 2;

# COMMAND ----------

spark.sql('use lgproject')
spdf_product=spark.sql('select * from product_sales')


# COMMAND ----------

# DBTITLE 1,renaming columns with underscore
new_columns = [col.replace(' ', '_') for col in spdf_product.columns]
spdf_product = spdf_product.toDF(*new_columns)
spdf_product.printSchema()

# COMMAND ----------

display(spdf_product.head(5))

# COMMAND ----------

display(spdf_product.tail(5))

# COMMAND ----------

# MAGIC %sql
# MAGIC --calculate high revenue generated product in the list with the details on producttype,sku,customer demo,products sold, revenue, exist
# MAGIC --find least amount least stock product
# MAGIC --which location has high production volumes
# MAGIC --highest defect rates

# COMMAND ----------

spdf_product_rvn=spark.sql('''
select `Product type`,SKU,`Customer demographics`,sum(`Number of products sold`) as No_of_products_sold,
'$'|| round(sum(coalesce(`Revenue generated`, 0))) as Total_Revenue
from product_sales
group by `Product type`,SKU,`Customer demographics`
order by Total_Revenue desc
''')
display(spdf_product_rvn.head(10))

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from product_sales limit 5

# COMMAND ----------

spdf_product_stck=spark.sql ('''
select SKU,min(`Stock levels`) as Min_Stocked_Prdcts
from product_sales
group by SKU
order by Min_Stocked_Prdcts asc
''')
display(spdf_product_stck.head(10))

# COMMAND ----------

# MAGIC %sql
# MAGIC --which location has high production volumes
# MAGIC select * from product_sales limit 5

# COMMAND ----------

spdf_product_prd= spark.sql ('''
select Location as Top_Production_Sites from product_sales 
group by Location,`Production volumes`
order by `Production volumes` desc
''')
display(spdf_product_prd.head(3))

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from product_sales limit 5

# COMMAND ----------

spdf_product_trnsprt_ration= spark.sql ('''
select `Transportation modes`,count(*) from product_sales
group by `Transportation modes`
''')
display(spdf_product_trnsprt_ration)

# COMMAND ----------

spdf_product_route_ratio= spark.sql ('''
select `Routes`,count(*) from product_sales
group by `Routes`
''')
display(spdf_product_route_ratio)

# COMMAND ----------

spdf_product_trnsprt_ratio= spark.sql ('''
select `Transportation modes`,`Supplier name`,SKU,`Product type`,sum(`Shipping costs`) from product_sales
group by `Transportation modes`,`Supplier name`,SKU,`Product type`
''')
display(spdf_product_trnsprt_ratio)

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from product_sales limit 5

# COMMAND ----------

spdf_product_rvnue= spark.sql ('''
select `Revenue generated`,`Product type`,sum(`Number of products sold`) as Sold_Products from product_sales
group by `Revenue generated`,`Product type`
''')
display(spdf_product_rvnue)
