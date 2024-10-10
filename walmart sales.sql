CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
      invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
      branch VARCHAR(30) NOT NULL,
      city VARCHAR(30) NOT NULL,
      customer_type VARCHAR(30) NOT NULL,
      gender VARCHAR(30) NOT NULL,
      product_line VARCHAR(30) NOT NULL,
      unit_price DECIMAL(10,2) NOT NULL,
      quantity INT NOT NULL,
      VAT FLOAT(6,4) NOT NULL,
      totla DECIMAL(12,4) NOT NULL,
      date DATETIME NOT NULL,
      time TIME NOT NULL,
      payment_method VARCHAR(15) NOT NULL,
      cogs DECIMAL(10,2) NOT NULL,
      gross_margin_pct FLOAT(11,9),
      gross_income DECIMAL(12,4) NOT NULL,
      rating FLOAT(2,1)
      );
      
# Add time_of_day column
      
      select
         time,
         (case
             when 'time' between "00:00:00" and "12:00:00" then "MORNING"
             when 'time' between "12:01:00" and "16:00:00" then "AFTERNOON"
             else "EVENING"
		 end
		 )as time_of_day
	  from sales;
      
      alter table sales add column time_of_day varchar(20);
      update sales
      set time_of_day=(
        case
           when 'time' between "00:00:00" and "12:00:00" then "MORNING"
		   when 'time' between "12:01:00" and "16:00:00" then "AFTERNOON"
             else "EVENING"
		 end
         );
# day_name
     
     select 
      date,
      DAYNAME(date)as day_name
      from sales;
      
      alter table sales add column day_name varchar(10);
      
      update sales
      set day_name=DAYNAME(date);
      
# month_name
      
      select 
      date,
      MONTHNAME(date)
      from sales;
      
      alter table sales add column month_name varchar(10);
      
      update sales
      set month_name=MONTHNAME(date);
      
      ----------------------------------------------------------------------------------------------------------------------------------------------------
# How many unique cities  does the data have?
      
      select distinct city from sales;
      
# In which city is each branch
      
      select distinct branch from sales;
      
      select distinct city,branch from sales;
      
      -------------------------------------------------------------------------------------------------------------------------------------------
# How many unique product line does the data have?
     
     select count(distinct product_line) from sales;
      
# What is the most common payment method?
      
      select 
      payment_method, 
      count(payment_method)as cnt 
      from sales
      group by payment_method
      order by cnt desc;
      
# what is the most selling product line?
      
      select 
      product_line,
      count(product_line)as cnt
      from sales
      group by product_line
      order by cnt desc;
      
# what is the total revenue by month?
      
      select
      month_name as month,
      sum(totla)as Total_revenue
      from sales
      group by month_name
      order by Total_revenue desc;
      
# what month had the largest cogs?
      
      select 
       month_name as month,
      sum(cogs)as cogs
      from sales
      group by month_name
      order by cogs desc;
      
# what product line had the largest revenue?
      
      select
	  product_line,
      sum(totla)as Total_revenue
      from sales
      group by product_line
      order by Total_revenue desc;
      
# what is the city with the largest revenue?
      
      select
       branch,city,
      sum(totla)as Total_revenue
      from sales
      group by city, branch
      order by Total_revenue desc;
      
# what product line had the largest VAT?
      
      select
       product_line,
      avg(VAT)as avg_tax
      from sales
      group by product_line
      order by avg_tax desc;
      
# which branch sold more products than average product sold?
      
      select
      branch,
      sum(quantity) as qty
      from sales
      group by branch
      having sum(quantity) > (select avg(quantity) from sales);
      
# what is the most common product line by gender?
      
      select 
       gender,product_line,
      count(gender)as Total_cnt
      from sales
      group by gender,product_line
      order by Total_cnt desc;
      
# what is the average rating of each product line?
      
      select
      round(avg(rating),2)as avg_rating,
      product_line
      from sales
      group by product_line
      order by avg_rating desc;
      
      ------------------------------------------------------------------------------------------------------------------------------------------------------
    
# Which of the customer types brings the most revenue?
      
      select
      customer_type,
      sum(totla) as total_rev
      from sales
      group by customer_type
      order by total_rev desc;
      
# Which city has the largest tax percent/VAT (value Added Tax)?
      
      select
      city,
      avg(VAT) as VAT
      from sales
      group by city
      order by VAT desc;
      
# Which customer type pays the most in VAT?
      
      select 
      customer_type,
      avg(VAT) as VAT
      from sales
      group by customer_type
      order by VAT desc;
      
      --------------------------------------------------------------------------------------------------------------------------------------------------
# How many unique customer types does the data have?
      
      select
      Distinct customer_type
      from sales;
      
# How many unique payment method does the data have?
      
      select
      distinct payment_method
      from sales;
      
# Which customer type buys the most?
      
      select 
      customer_type,
      count(*) as cstm_cnt
      from sales
      group by customer_type;
      
# What is the gender of most of the customers?
      
      select
      gender,
      count(*) as gender_cnt
      from sales
      group by gender
      order by gender_cnt desc;
      
# What is the gender distribution per branch?
      
      select 
      gender,branch,
      count(*) as gender_cnt
      from sales
      where branch in ('A','B','C')
      group by gender,branch
      order by gender_cnt,branch desc;
      
# Which time of the day do customers give most ratings?
      
      select 
      time_of_day,
      avg(rating) as avg_rating
      from sales
      group by time_of_day
      order by avg_rating;
      
# Which day of the week has the best avg rating?
      
      select
      day_name,
      avg(rating) as avg_rating
      from sales
      group by day_name
      order by avg_rating desc;
      
# Which day of the week has the best average ratings per branch?
      
       select 
      day_name,branch,
      avg(rating) as avg_rating
      from sales
      where branch in ('A','B','C')
      group by day_name,branch
      order by branch,avg_rating desc;
       