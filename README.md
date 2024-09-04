# Amazon Sales Insight Project

## Project Overview
This project involves analyzing sales data from three Amazon branches located in Mandalay, Yangon, and Naypyitaw. The dataset consists of 1000 rows and 17 columns, including invoice details, product lines, prices, quantities, taxes, dates, and customer demographics. The goal is to leverage this data to enhance sales strategies, improve product offerings, and gain a deeper understanding of customer segments.

## Business Problem
Amazon seeks to understand various factors influencing sales across its branches to optimize business strategies. Key challenges include identifying high-performing product lines, understanding sales trends over time, and segmenting customers based on purchasing behavior. Addressing these challenges will help Amazon refine its product offerings, tailor marketing strategies, and ultimately increase revenue.

## Project Scope
1. **Data Wrangling**:
   - Inspect and clean the data, ensuring no null values.
   - Build a database, create tables, and insert the cleaned data.
  
2. **Feature Engineering**:
   - Create new columns for the time of day, day of the week, and month of the year to gain insights into sales patterns.
  
3. **Exploratory Data Analysis (EDA)**:
   - Analyze product performance to identify the best and worst-performing product lines.
   - Examine sales trends to evaluate the effectiveness of sales strategies.
   - Segment customers to uncover purchase trends and profitability by customer type.
  
4. **Business Questions**:
   - Address specific business questions related to product lines, payment methods, revenue, VAT, customer types, and ratings.

## Business Objectives
1. **Product Analysis**: Evaluate the performance of different product lines to identify top-performing products and those needing improvement.
2. **Sales Analysis**: Examine sales trends to measure the effectiveness of sales strategies and identify areas for improvement.
3. **Customer Analysis**: Uncover different customer segments, purchase trends, and the profitability of each customer segment.

## Technical Stack
- **Data Source**: CSV File
- **Tools Used**: SQL
- **Data Dimensions**: 20 columns and 1000 rows

## Data Understanding
- **Data Dictionary**: Key columns include invoice_id, branch, city, customer_type, gender, product_line, unit_price, quantity, vat, total, purchase_date, purchase_time, payment_method, cogs, gross_margin_percentage, gross_income, rating, time_of_day, name_of_day, name_of_month.

## Entity-Relationship Diagram
- An ERD was created to map the relationships between different entities within the dataset.

## Insights and Recommendations

### Product Insights
- **Top Performing**: Food and Beverages is the highest revenue-generating product line, with the highest rating and the second-most sold items.
  - **Recommendation**: Maintain ample stock levels to meet customer demand and ensure satisfaction.

- **Improvement Needed**: Health and Beauty is the lowest-performing product line.
  - **Recommendation**: Gather customer feedback and introduce innovative products aligned with market trends.

### Sales Insights
- **Peak Sales Periods**: Afternoon hours are the peak sales period across all product lines.
  - **Recommendation**: Optimize product displays and offer special deals during off-peak hours.

- **Top Selling Products**: Electronic accessories are the most sold, while Health and Beauty products are the least sold.
  - **Recommendation**: Consider promotions or discounts on Health and Beauty products and enhance their marketing.

### Customer Insights
- **Gender Split**: Customer base is evenly split between male and female.
  - **Recommendation**: Tailor marketing efforts to align with distinct gender preferences and purchasing patterns.

- **Payment Method**: Ewallet is the most frequently used payment method.
  - **Recommendation**: Implement exclusive offers for Ewallet transactions.

- **Branch Performance**: Highest revenue from Naypyitaw and lowest from Mandalay.
  - **Recommendation**: Collaborate with local businesses for cross-promotions in low-revenue cities.

## Conclusion
This project provides actionable insights into Amazon’s sales data, helping to optimize product offerings, enhance customer satisfaction, and improve overall business performance.
