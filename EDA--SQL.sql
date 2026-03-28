Use Reetique_Store;


CREATE TABLE SalesData (
    Segment VARCHAR(50),
    Country VARCHAR(50),
    Product VARCHAR(50),
    Discount_Band VARCHAR(50),
    Units_Sold DECIMAL(10, 2),
    Manufacturing_Price DECIMAL(10, 2),
    Sale_Price DECIMAL(10, 2),
    Gross_Sales DECIMAL(15, 2),
    Discounts DECIMAL(15, 2),
    Sales DECIMAL(15, 2),
    COGS DECIMAL(15, 2),
    Profit DECIMAL(15, 2),
    Sale_Date DATE
);

BULK INSERT SalesData
FROM "C:\Users\NAJISH\Downloads\Fin Data.csv"
WITH (           
    FIRSTROW = 2,               
    FIELDTERMINATOR = ',',       
    ROWTERMINATOR = '\n',        
    TABLOCK                      
);

-----Which Country generates the highest Revenue and Profit?

select Top 1 Country,sum(Sales) as Revenue ,
Sum(COGS) Cost,SUM(Profit) as Profit
from SalesData group by Country order by Revenue desc;

----Which Product has the highest total Units Sold?

select Top 1 Product,sum(Units_Sold)
as Total_Quantity from SalesData
group by Product order by Total_Quantity desc;

----Which market Segment  is the most profitable?

select Segment,sum(Profit) as Profit 
from SalesData group by Segment 
order by Sum(Profit) desc;

-----Is there a strong correlation between the Discount Band  
-----and the number of Units Sold?

select Discount_Band,sum(Units_Sold) as Quantity from SalesData 
group by Discount_Band order by Sum(Units_Sold) desc;

----In which Month Name does the company experience its peak Sales,
----and does this trend repeat in both 2013 and 2014?

select MONTH(Sale_Date) as Month,YEAR(Sale_Date) as Year,
sum(Sales) As Revenue from SalesData
group by Month(Sale_Date) , YEAR(Sale_Date);

----What is the average Profit Margin for each Product?

With Profit AS (
select PRODUCT,sum(Sales) as Revenue,
sum(Profit) as Profit from SalesData
group by Product)

select *,(Profit/Revenue) * 100 as Profit_Margin  
from Profit;

----Which Product has the highest COGS relative to its Sales?

with Costt as (

select Product,sum(COGS) as Cost, sum(Sales) as Revenue 
from SalesData   group by Product 
)

select * from Costt
where Cost> Revenue
;


-----What is the  "Markup Price"
----(the difference between Manufacturing Price and Sale Price) for each product?

select Product,sum(Sale_Price) AS Sale_Price,
sum(Manufacturing_Price) AS Manu_Price,
sum(Sale_Price)-sum(Manufacturing_Price) as Markup_Price
from SalesData group by Product Order by Manu_Price desc;

----What is the total Discount amount given per Country, and how does it compare to the Gross Sales?

Select Country,sum(Discounts) as Discount,
sum(Gross_Sales) as Gross_Revenue 
from SalesData group by Country
order by Discount desc
;


----What is the percentage growth in total Profit from 2013 to 2014?

with Yearly_Profit As 
(
select
sum(case when Year(Sale_Date)=2013 Then Profit else 0 end) as Profit_2013,
sum(case when year(Sale_Date)=2014 Then Profit else 0 end) as Profit_2014
from SalesData
)
select * , (Profit_2014-Profit_2013)/(Profit_2013)*100 as [Percentage_Growth%]
from Yearly_Profit;



