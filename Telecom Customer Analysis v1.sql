--1 a.How many customers were referred from 'San Diego' city? 
--  b.What is the percentage of people joined through referrals comparing to the total population.
--a
select 
  sum(
    cast([Number of Referrals] as int)
  ) as Total_Referrals, 
  [City] 
from 
  [dbo].[telecom_customer_churn] 
where 
  upper([City])= 'SAN DIEGO' 
group by 
  City 
  --b
select 
  sum(
    cast([Number of Referrals] as int)
  ) as Total_Referrals, 
  City, 
  sum(
    cast([Population] as int)
  ) as Total_Population, 
  sum(
    cast([Number of Referrals] as int)
  )/ sum(
    cast([Population] as int)
  ) as Referral_Percentage 
from 
  [dbo].[telecom_customer_churn] cstmr 
  left join [dbo].[telecom_zipcode_population] zpcd on cstmr.[Zip Code] = zpcd.[Zip Code] 
group by 
  City 
order by 
  Referral_Percentage desc 
  --2. What seem to be the key drivers of customer churn?
select 
  top 10 count([Churn Reason]) as Total_Count, 
  [Churn Reason], 
  [Churn Category] 
from 
  [dbo].[telecom_customer_churn] 
where 
  lower([Customer Status]) in ('churned') 
group by 
  [Churn Reason], 
  [Churn Category] 
order by 
  Total_Count desc 
  --3 .Is the company losing high value customers? If so, how can they retain them?
Select 
  count([Customer Status]) as Count_Of_Churned_Customers 
from 
  [dbo].[telecom_customer_churn] 
where 
  lower([Customer Status]) in ('churned') 
  --To retain the customers, company has to work on the following reasons.
Select 
  distinct [Churn Reason] 
from 
  [dbo].[telecom_customer_churn] 
where 
  lower([Customer Status]) in ('churned') 
  --4.What is the total revenue earned by company on different age groups?
  With Age_Bin as (
    Select 
      case when [Age] < 20 then 'Below 20' when [Age] between 20 
      and 40 then 'Above 20 and Below 40' when [Age] between 40 
      and 60 then 'Above 40 and Below 60' when [Age] > 60 then 'Above 60' end as Age_Gap, 
      [Total Revenue] 
    from 
      [dbo].[telecom_customer_churn]
  ) 
Select 
  Count(*) as Total_Cnt, 
  concat(
    cast(
      sum(
        cast([Total Revenue] as decimal)
      )/ 1000000 as decimal(10, 2)
    ), 
    ' M'
  ) as Revenue, 
  Age_Gap 
from 
  Age_Bin 
group by 
  Age_Gap 
order by 
  2 desc
