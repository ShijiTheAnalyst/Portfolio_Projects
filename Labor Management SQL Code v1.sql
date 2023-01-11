USE [SQL_Tutorials] 
/****About the Table Set*******/
--[dbo].[stage.amps_assets]--This table contains information about objects that work orders can be written to. 
--[dbo].[stage.amps_labor]--This table contains work order labor records. 
--[dbo].[stage.amps_work_orders] --This table is the primary table for information about work orders


--1 Query Results with the Count of Labors on Each Work Category
 /*Business Metrics- Total Labor Work Force */
select 
  coalesce(
    Evt_Class, 'Miscellanious_Activities'
  ) as Category, 
  count(boo_event) as Cnt 
from 
  [dbo].[stage.amps_work_orders] wrk_ord 
  join [dbo].[stage.amps_labor] lbr on wrk_ord.EVT_CODE = lbr.BOO_EVENT 
group by 
  Evt_Class 
order by 
  2 desc 
  
 --2 Query Results the Average Labor Salary for the year 2014
  /*Business Metrics- Average Laborer Salary */
Select 
  FORMAT (
    avg(boo_cost), 
    'c', 
    'hi-IN'
  ) as Avg_Labor_Slry, 
  Boo_Trade as Labor_Profile 
from 
  [dbo].[stage.amps_work_orders] wrk_ord 
  join [dbo].[stage.amps_labor] lbr on wrk_ord.EVT_CODE = lbr.BOO_EVENT 
where 
  year(
    cast(evt_date as date)
  )= '2014' 
group by 
  Boo_Trade 
order by 
  avg(boo_cost) desc 
 
 --3 Query Results with the Detail of Defect Objects and their Related Labor Hours and Object-Issues.
/*Business Metrics- Billable Hours  */
Select 
  [OBJ_CLASS] as Object_Name, 
  coalesce(
    [EVT_REQM], 'Miscellanious_Activities'
  ) as Issue_Type, 
  cast(
    sum([BOO_HOURS]) as decimal(10, 2)
  ) as Total_Labor_Hours, 
  Rank() over (
    order by 
      sum([BOO_HOURS]) Desc
  ) as Rnk 
from 
  [dbo].[stage.amps_work_orders] wrk_ord 
  join [dbo].[stage.amps_assets] asset on cast(
    wrk_ord.evt_object as varchar(100)
  )= cast(
    asset.obj_code as varchar(100)
  ) 
  join [dbo].[stage.amps_labor] lbr on wrk_ord.EVT_CODE = lbr.BOO_EVENT 
group by 
  [OBJ_CLASS], 
  [EVT_REQM] 
  
  --4 Query Results the Count of Works falls on Different Priorities
  /*Business Metrics- Priority Class Count  */
select 
  Replace([EVT_PRIORITY], '*', 'NA') as Priority_Class, 
  count([EVT_REQM]) as Wrk_Cnt 
from 
  [dbo].[stage.amps_labor] lbr 
  join [dbo].[stage.amps_work_orders] wrk_ord on wrk_ord.EVT_CODE = lbr.BOO_EVENT 
where 
  [EVT_PRIORITY] is not null 
group by 
  [EVT_PRIORITY] 
order by 
  2 desc 
  
 --5 Query Results with the count of Not Assigned Work to Laborers
   /*Business Metrics- Count of Un-Assigned Work Orders */
select 
  count(*) as Un_Assgnd_Wrk_Cnt
from 
  [dbo].[stage.amps_labor] lbr 
  left join [dbo].[stage.amps_work_orders] wrk_ord on wrk_ord.EVT_CODE = lbr.BOO_EVENT 
where 
  wrk_ord.EVT_CODE is null 
  
 --6 Query Results the List of Computers,Laptops,Printers,Wireless Equipments allocated for Departments- DISTRICT& FORESTRY
    /*Business Metrics- Departmentwise Object Count */
 With assets as (
    select 
      * 
    from 
      [dbo].[stage.amps_assets] 
    where 
      obj_class in (
        'COMPUTER', 'LAPTOP', 'PRINTER', 'WIRELESS'
      )
  ), 
  orders as (
    select 
      * 
    from 
      [dbo].[stage.amps_work_orders] 
    where 
      [EVT_UDFCHAR03] in ('DISTRICT', 'FORESTRY')
  ) 
select 
  [EVT_UDFCHAR03] as Department, 
  count(obj_class) as Equipments 
from 
  orders 
  left join assets on cast(
    orders.evt_object as varchar(100)
  )= cast(
    assets.obj_code as varchar(100)
  ) 
group by 
  [EVT_UDFCHAR03]
