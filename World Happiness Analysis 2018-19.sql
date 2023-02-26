/*Dataset taken from - https://www.kaggle.com/datasets/synful/world-happiness-report?select=2019.csv*/

/*Grouping countries and Scores*/
With Happiness_Table as (
  select 
    case when score >= cast(
      0 as varchar(50)
    ) 
    and score <= cast(
      3 as varchar(50)
    ) then 'Happiness Score Below 3' when score > cast(
      3 as varchar(50)
    ) 
    and score <= cast(
      6 as varchar(50)
    ) then 'Happiness Score between 3-6' when score >= cast(
      7 as varchar(50)
    ) 
    and score <= cast(
      12 as varchar(50)
    ) then 'Happiness Score between 6-10' else 'Happiness Score not found' end as Score_Type, 
    [Country or region] as Region 
  FROM 
    [SQL_Tutorials].[dbo].[World_Happiness_2019]
) 
SELECT 
  t.Score_Type, 
  STUFF(
    (
      SELECT 
        ',' + s.Region 
      FROM 
        Happiness_Table s 
      WHERE 
        s.Score_Type = t.Score_Type FOR XML PATH('')
    ), 
    1, 
    1, 
    ''
  ) AS Country_List 
FROM 
  Happiness_Table AS t 
GROUP BY 
  t.Score_Type 
  /*Find the countries who secured rank Top 10 consecutively for year 2018 and 2019*/
select 
  A.[Country or region] AS Country 
FROM 
  [SQL_Tutorials].[dbo].[World_Happiness_2019] A 
  JOIN [SQL_Tutorials].[dbo].[World_Happiness_2018] B ON A.[Country or region] = B.[Country or region] 
WHERE 
  A.[Overall rank] BETWEEN 1 
  AND 10 
  AND B.[Overall rank] BETWEEN 1 
  AND 10
