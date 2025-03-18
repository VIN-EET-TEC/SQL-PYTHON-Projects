# Walmart Data Analysis

## Project Steps

### 1. Download Walmart Sales Data

- **Data Source**: Use the Kaggle API to download the Walmart sales datasets from Kaggle.
- **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)

### 2. Install Required Libraries and Load Data

- **Libraries**: Install necessary Python libraries using:
```
!pip install ipython-sql prettytable
!pip install pandas 
import prettytable

prettytable.DEFAULT = 'DEFAULT'

```
```
import csv, sqlite3
import pandas as pd
con = sqlite3.connect("FinalDB.db")
cur = con.cursor()

```
- **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 3. Explore the Data

- **Goal**: Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
- **Analysis**: Use functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 4. Data Cleaning

- **Remove Duplicates**: Identify and remove duplicate entries to avoid skewed results.
- **Handle Missing Values**: Drop rows or columns with missing values if they are insignificant; fill values where essential.
- **Fix Data Types**: Ensure all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
- **Currency Formatting**: Use `.replace()` to handle and format currency values for analysis.
- **Validation**: Check for any remaining inconsistencies and verify the cleaned data.

### 5. Feature Engineering

- **Create New Columns**: Calculate the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
- **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 6. Load Data into MySQL and PostgreSQL

- **Set Up Connections**: Connect to MySQL and load the cleaned data into each database.
- **Table Creation**: Set up tables in MySQL using Python to automate table creation and data insertion.
- **Verification**: Run initial SQL queries to confirm that the data has been loaded accurately.

### 7. SQL Analysis: Complex Queries and Business Problem Solving

- **Business Problem-Solving**: Write and execute complex SQL queries to answer critical business questions, such as:
- Revenue trends across branches and categories.
- Identifying best-selling product categories.
- Sales performance by time, city, and payment method.
- Analyzing peak sales periods and customer buying patterns.
- Profit margin analysis by branch and category.
- **Documentation**: Keep clear notes of each query's objective, approach, and results.

### Data Analysis & Findings

**Q1: Find different payment methods, number of transactions, and quantity sold by payment method.**

```sql
SELECT 
    payment_method,
    COUNT(*) AS no_of_payments,
    SUM(quantity) AS no_qty_sold
FROM
    walmart
GROUP BY payment_method;

```

**Q2: Identify the highest-rated category in each branch.**
- Display the branch, category, and avg rating

```sql
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        ROUND(AVG(rating),2) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rankk
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rankk = 1
LIMIT 10;

```

**Q3: Identify the busiest day for each branch based on the number of transactions.**

```sql
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(date) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankk
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rankk = 1
LIMIT 10;

```

**Q4: Calculate the total quantity of items sold per payment method.**

```sql
SELECT 
    payment_method, SUM(quantity) AS no_qty_sold
FROM
    walmart
GROUP BY payment_method;

```

**Q5: Determine the average, minimum, and maximum rating of categories for each city.**

```sql
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    ROUND(AVG(rating), 2) AS avg_rating
FROM
    walmart
GROUP BY city , category
LIMIT 10;

```

**Q6: Calculate the total profit for each category.**

```sql
SELECT 
    category,
    ROUND(SUM(unit_price * quantity * profit_margin),
            2) AS total_profit
FROM
    walmart
GROUP BY category
ORDER BY total_profit DESC;

```

**Q7: Determine the most common payment method for each branch.**

```sql
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankK
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rankK = 1
LIMIT 10;

```

**Q8: Categorize sales into Morning, Afternoon, and Evening shifts.**

```sql
SELECT 
    branch,
    CASE
        WHEN HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM
    walmart
GROUP BY branch , shift
ORDER BY branch , num_invoices DESC;

```

## Author
- **Email**: vineetgupta798@gmail.com
- **LinkedIn**: [vineet-gupta-01b317231](https://www.linkedin.com/in/vineet-gupta-01b317231/)

