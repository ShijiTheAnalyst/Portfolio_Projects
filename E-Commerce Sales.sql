/*Source Dataset - https://www.kaggle.com/datasets/berkayalan/ecommerce-sales-dataset?resource=download*/
--Tables Used [dbo].[basket_details] and [dbo].[customer_details]
--1.How many products were sold for June Month 2019?
select 
  count(distinct [product_id]) as Products_Cnt 
FROM 
  [SQL_Tutorials].[dbo].[basket_details] 
where 
  basket_date like '2019-06-%' 
  --2.What is the ratio of men to women ?
  with total as (
    select 
      count(
        case when lower(sex)= 'female' then 1 end
      ) as Female_Cnt, 
      count(
        case when lower(sex)= 'male' then 1 end
      ) as Male_Cnt, 
      count(*) as Total_Cnt 
    from 
      [SQL_Tutorials].[dbo].[customer_details] 
    where 
      lower(sex) in ('male', 'female')
  ) 
select 
  concat(
    (Female_Cnt * 100 / Total_Cnt), 
    '%'
  ) as Female_Percentage, 
  concat(
    (male_Cnt * 100 / Total_Cnt), 
    '%'
  ) as Male_Percentage 
from 
  total 
  --3.Which all products where purchased more than 5 times each month along month details?
select 
  datename(m, basket_date)+ ' ' + cast(
    datepart(yyyy, basket_date) as varchar
  ) as Month_Of_Purchase, 
  product_id 
from 
  [SQL_Tutorials].[dbo].[basket_details] bskt 
where 
  basket_count > 5 
order by 
  basket_date asc 
  --4.What is the percentage of senior class citizens purchases from Wow SuperMarket?
  With CTE as (
    select 
      count(
        case when cast(
          replace(customer_age, '.0', '') as int
        )>= 60 then 1 end
      ) as Snr_Cls_Cnt, 
      count(*) as Total_Cnt 
    from 
      [SQL_Tutorials].[dbo].[customer_details]
  ) 
select 
  concat(
    (Snr_Cls_Cnt * 100 / Total_Cnt), 
    '%'
  ) as Snr_Cls_Ctzn_Prcntg 
from 
  CTE
