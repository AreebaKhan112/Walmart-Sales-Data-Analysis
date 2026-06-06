## Walmart Sales Analysis: SQL Exploration & Power BI Dashboard

An end-to-end data analytics project performing sales and profit analysis on a Walmart retail dataset.The workflow covers raw data cleaning and standardization in Python, complex business question exploration using SQL (SQLite), and the design of an interactive executive dashboard in Power BI.

### 📊 Project Overview & Architecture
* **Dataset:** 9,969 transactions across 100 branches and 98 cities in Texas, spanning January 2019 to December 2023.
* **Core Goal:** To build a robust data pipeline that transforms raw transactional data into actionable business insights—identifying top profit centers, customer behavior patterns, and critical revenue risks.

---

### 🛠️ Tech Stack & Skills Demonstrated
* **Data Cleaning (Python/pandas):** Handled missing values, removed duplicate invoice records, standardized date types (`DD/MM/YY`), trimmed whitespace, and cast fields to correct data types.
* **SQL Analysis (SQLite):** Developed 9 business-driven queries using aggregate functions, `GROUP BY` optimization, `CASE` statements, date parsing via `strftime`, Window Functions (`RANK() OVER (PARTITION BY ...)`), and Multi-CTE Joins.
* **Data Visualization (Power BI):** Formatted advanced interactive dashboards using KPI summary cards, customized column/bar charts, stacked distribution charts, and conditional alert tables.

---

### 📈 Key Insights & Business Findings

* **Top Profit Drivers:** *Fashion accessories* and *Home and lifestyle* dominate profitability, with each contributing approximately **\$192K** to the total profit.
* **Lowest Performing Category:** *Health and beauty* generated the lowest profit at roughly **\$19K**. Actionable steps include collaborating with marketing to boost category visibility and optimizing pricing models.
* **Transaction Habits:** Credit cards lead consumer preference (~4,300 transactions), closely followed by Ewallets (~3,900 transactions). Together, they represent over **80%** of all sales payment methods.
* **Peak Traffic Windows:** Store transaction volume spikes heavily in the **Afternoon** across tracked branches, while Mornings consistently show the lowest volume, highlighting an opening for morning-specific promotional campaigns.
* **Priority Risk Alerts (YoY Revenue Decline):** Advanced CTE metrics flagged severe 2022–2023 revenue drops in specific branches, led by `WALM045` with a **62.62%** drop and `WALM047` with a **58.58%** decline, signaling areas requiring immediate operational investigation.

---

### 🖥️ Dashboard Preview
The final interactive Power BI dashboard features high-level KPI tracking showing **\$1.21M Total Revenue**, **\$476K Total Profit**, and **23.48K total units sold** alongside cross-filtering visual components:

* **KPI Summary Cards:** Top-line performance overview.
* **Profit by Category:** Distinct breakdown of product vertical success.
* **Transactions by Payment Method:** Volume distribution across Credit, Ewallet, and Cash.
* **Sales by Time of Day:** Stacked visual map outlining hourly volume shifts per branch.
* **Revenue Decline Table:** High-alert tracking of underperforming locations.

---

### 🚀 How to Reproduce
1. **Clean the Data:** Run the `data_cleaning.py` notebook to transform the raw source file into `cleaned_walmart_data.csv`.
2. **Execute Queries:** Load `cleaned_walmart_data.csv` into any SQLite client and execute the numbered steps (`Q1` through `Q9`) inside `queries.sql`.
3. **Open the Dashboard:** Open `Walmart_Sales_Dashboard.pbix` in Power BI Desktop and change the data source path to point to your local `cleaned_walmart_data.csv`.
