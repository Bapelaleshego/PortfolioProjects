SELECT *
FROM bikesales.bike_sales;

--- Looking at total number of sales
SELECT 
COUNT(Day) AS Total_Sales
FROM bikesales.bike_sales;

--- Looking at total revenue
SELECT 
SUM(Revenue) AS Total_Revenue
FROM bikesales.bike_sales;

--- Total amount of profit made
SELECT 
SUM(Profit) AS Total_Profit
FROM bikesales.bike_sales;

--- Total products sold 
SELECT 
SUM(Order_Quantity) AS Total_Items_Sold
FROM bikesales.bike_sales;

--- Which year had the most sales, revenue and profit
SELECT 
     Year,SUM(Order_Quantity),SUM(Revenue),SUM(Profit)
FROM bikesales.bike_sales
GROUP BY YEAR
ORDER BY 1 ASC;

--- Which country had the most order quantity, revenue and profit
SELECT 
     Country,SUM(Order_Quantity),SUM(Revenue),SUM(Profit)
FROM bikesales.bike_sales
GROUP BY Country
ORDER BY 4 ASC;

--- Which product category had the most order quantity, revenue and profit
SELECT 
     Product_Category,SUM(Order_Quantity),SUM(Revenue),SUM(Profit)
FROM bikesales.bike_sales
GROUP BY Product_Category
ORDER BY 4 ASC;

--- Top 10 highest sold products
SELECT 
     Product,SUM(Order_Quantity),SUM(Revenue),SUM(Profit)
FROM bikesales.bike_sales
GROUP BY Product
ORDER BY 4 DESC
LIMIT 10;

--- Top 3 months with the most order quantity per year
	WITH Top3MonthsPerYear AS
    (
    SELECT Month,Year, Sum(Order_Quantity) AS Total_Products_Sold
    FROM bikesales.bike_sales
    GROUP BY Month,Year
    ),
    Months_Year_Rank AS
    (
    SELECT Month,Year,Total_Products_Sold, DENSE_RANK() OVER (PARTITION BY YEAR ORDER BY Total_Products_sold DESC) AS Ranking
    FROM Top3MonthsPerYear
    )
    SELECT Month,Year,Total_Products_Sold,Ranking
    FROM Months_Year_Rank
    WHERE Ranking <=3
    ORDER BY Year ASC;
 
 --- Top 5 performing products per product category
 	WITH Top5PerformingProducts AS
    (
    SELECT Product_Category,Product, Sum(Order_Quantity) AS Total_Products_Sold
    FROM bikesales.bike_sales
    GROUP BY Product_Category,Product
    ),
    Product_Category_Rank AS
    (
    SELECT Product_Category,Product,Total_Products_Sold, DENSE_RANK() OVER (PARTITION BY Product_Category ORDER BY Total_Products_sold DESC) AS Ranking
    FROM Top5PerformingProducts
    )
    SELECT Product_Category,Product,Total_Products_Sold,Ranking
    FROM Product_Category_Rank
    WHERE Ranking <=5
    ORDER BY Ranking ASC;
    
    --- Top 5 products with the highest profit per country
 	WITH High_Profit AS
    (
    SELECT Country,Sub_Category,Sum(Profit) AS Total_Profit
    FROM bikesales.bike_sales
    GROUP BY Country,Sub_Category
    ),
    Profit_Rank AS
    (
    SELECT Country,Sub_Category,Total_Profit, DENSE_RANK() OVER (PARTITION BY Country ORDER BY Total_Profit DESC) AS Ranking
    FROM High_Profit
    )
    SELECT Country,Sub_Category,Total_Profit,Ranking
    FROM Profit_Rank
    WHERE Ranking <=5
    ORDER BY Country,Ranking ASC;