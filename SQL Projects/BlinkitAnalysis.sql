
use blinkitdb;
select * from blinkit_data;
select count(*) from blinkit_data;

-- cleaning the data
update blinkit_data SET Item_Fat_Content = 
CASE 
	WHEN Item_Fat_Content IN ('LF', 'low_fat') THEN 'Low Fat'
	WHEN Item_Fat_Content = 'reg' THEN 'Regular'
	ELSE Item_Fat_Content
END;

SELECT DISTINCT(Item_Fat_Content) from blinkit_data;

-- KPIs - 

-- Total Sales
SELECT SUM(Sales)Total_Sales  FROM blinkit_data;

-- Show the total sales in millions instead
SELECT CONCAT(CAST(SUM(Sales)/1000000 AS DECIMAL(10,2)), 'M') Total_Sales_Millions 
FROM blinkit_data;

-- Average Sales
SELECT ROUND(AVG(Sales), 0) Average_Sales from blinkit_data;

-- No. of items
SELECT COUNT(*) No_Of_Items FROM blinkit_data;

-- Average rating
SELECT ROUND(AVG(Rating),2) Avg_Rating FROM blinkit_data;


-- GRANULAR REQUIREMENTS

-- 1. Total_Sales by Fat Content
SELECT Item_Fat_Content, CONCAT(CAST(SUM(Sales)/1000 AS DECIMAL(10,2)), 'K') Total_Sales_Thousands,
						 ROUND(AVG(Sales), 0) Average_Sales_Thousands,
						 COUNT(*) No_Of_Items,
						 ROUND(AVG(Rating),2) Avg_Rating
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;

-- CONCLUSION 

-- low_fat items have more sales, though the avgerage sales is less, but the more no. of items are being sold, 
-- but giving more revenue. 

-- 2. Total Sales by Item Type
SELECT TOP 5 Item_Type, CAST(SUM(Sales) AS DECIMAL(10,2)) Total_Sales,
				  ROUND(AVG(Sales), 1) Average_Sales,
				  COUNT(*) No_Of_Items,
				  ROUND(AVG(Rating),2) Avg_Rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- 3. Fat Content by Outlet for Total Sales
SELECT Outlet_Location_Type, 
	   ISNULL([Low Fat], 0) Low_Fat,
	   ISNULL([Regular], 0) Regular
FROM
(
	SELECT Outlet_Location_Type, Item_Fat_Content, 
		   ROUND(SUM(Sales), 2) Total_Sales
	FROM blinkit_data
	GROUP BY Outlet_Location_Type, Item_Fat_Content
) sourceTable
PIVOT        -- to transform the rows into columns
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat], [Regular])
) PivotTable
ORDER BY Outlet_Location_Type;

-- CONCLUSION 

-- We can say that low fat items are mostly sold in Tier 3 locations and so as the regular items, 
-- means, tier 3 locations are the most profitable location as well and Tier 1 being the less profitable.

-- 4. Total Sales, avg sales, no.of items and avg rating by Outlet Establishment Year
SELECT Outlet_Establishment_Year, 
	   ROUND(SUM(Sales), 2) Total_Sales,
	   ROUND(AVG(Sales), 1) Average_Sales,
	   COUNT(*) No_Of_Items,
	   ROUND(AVG(Rating),2) Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC

-- CONCLUSION 

-- Blinkit being opened in 2011, the sales were less, though in 2018, it performed well and gave highest sales 
-- with highest no. of items being sold. In most recent year 2022, the avg sales seems to be highest with almost 
-- similar no. of items being sold comparatively with a total sales of 1,31,477.78


-- 5. Percentage of Sales by Outlet Size
select Outlet_Size, 
	   ROUND(SUM(Sales),2) Total_Sales,
	   CONCAT(CAST((SUM(Sales)*100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10, 2)),'%') SalesPercentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC

-- CONCLUSION

-- Medium sized stores are performing way better than higher sized outlets(almost twice)

-- RECOMMENDATION
-- Bigger outlets can be converted iinto 2 medium size outlets so as to cater 2 locations and 
-- thus can effectively contribute in the sales.


-- 6. Sales by outlet location
SELECT Outlet_Location_Type, 
	   ROUND(SUM(Sales), 2) Total_Sales,
	   CONCAT(CAST((SUM(Sales)*100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10, 2)),'%') SalesPercentage,
	   ROUND(AVG(Sales), 1) Average_Sales,
	   COUNT(*) No_Of_Items,
	   ROUND(AVG(Rating),2) Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC

-- CONCLUSION

-- The best performing location is Tier 3, giving highest number of sales - 39.29% with highest no. of items being sold. 


-- All metrics by outlet type
SELECT Outlet_Type, 
	   ROUND(SUM(Sales), 2) Total_Sales,
	   CONCAT(CAST((SUM(Sales)*100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10, 2)),'%') SalesPercentage,
	   ROUND(AVG(Sales), 1) Average_Sales,
	   COUNT(*) No_Of_Items,
	   ROUND(AVG(Rating),2) Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC

-- CONCLUSION

-- Supermarket type1  is performing exception cmparatively with highest sales of almost 66% among the other outlets, 
-- though the average sales is kind of same but seeling highest no. of items.

