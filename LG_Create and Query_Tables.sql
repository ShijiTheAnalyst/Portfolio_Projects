-- Databricks notebook source
-- MAGIC %md ## Author: Shiji  Copyright 02/06/2023

-- COMMAND ----------

-- MAGIC %md # Create SQL Tables...

-- COMMAND ----------

-- DBTITLE 1,Create Database
CREATE DATABASE IF NOT EXISTS lgproject

-- COMMAND ----------

USE lgproject

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### New Syntax requirement - must use absolute file path, need to add / to beginning of path.

-- COMMAND ----------

DROP TABLE IF EXISTS product_sales;

CREATE TABLE product_sales USING csv 
OPTIONS (path "/FileStore/tables/supply_chain_data-1.csv", header "true", inferSchema="true");

SELECT * FROM product_sales limit 2;
