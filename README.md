# USDA Agricultural Production Analysis

A SQL project using USDA agricultural production data to look at how production varies across U.S. states, years, and commodities.

I built this project to practice taking raw production data and turning it into actual analysis instead of just running basic `SELECT` statements. The queries start simple and gradually become more analytical, using things like joins, conditional aggregation, CTEs, percentage calculations, and comparisons across multiple commodities.

## What I wanted to find

The main goal was to answer questions like:

* Which states produce the most of each commodity?
* How did production change from 2021 to 2022?
* Which states had the biggest increases or decreases?
* Which states grew the most by percentage?
* How does milk production compare with cheese production?
* What percentage of U.S. production comes from each state?
* Which commodity is the largest within each state?

I wanted the project to build toward these questions rather than have a bunch of unrelated SQL queries.

---

## Data

The project uses USDA agricultural production data with separate production tables for different commodities, along with a state lookup table.

The production tables use fields such as:

* `State_ANSI` — state identifier
* `Year` — production year
* `Period` — reporting period
* `Value` — reported production value

The `state_lookup` table is used to turn the state identifiers into readable state names.

The analysis covers six commodities:

* Milk
* Cheese
* Yogurt
* Eggs
* Honey
* Coffee

This allows me to look at production patterns both within individual commodities and across states.

For annual analysis, I filter the production data to records where:

```sql
WHERE Period = 'YEAR'
```

This is important because the tables can contain different reporting periods, and mixing monthly and annual records would distort the results.

> **Source:** USDA agricultural production data
> Exact USDA dataset names and source links will be documented here.

---

## How the project is organized

I structured the analysis so that each stage builds on what came before it.

### 1. Basic production analysis

The first queries focus on getting comfortable with the data:

* Total production
* Production by state
* Production by year
* State-level commodity production
* Joining production tables with the state lookup table

This is where I established the basic patterns used throughout the project:

```sql
SELECT
FROM
WHERE
GROUP BY
ORDER BY
JOIN
SUM()
```

### 2. Year-over-year analysis

After getting the basic totals working, I moved into comparing production between years.

For example, I used conditional aggregation to get 2021 and 2022 production in the same row:

```sql
SUM(
    CASE
        WHEN Year = 2021 THEN Value
        ELSE 0
    END
) AS Production_2021
```

and:

```sql
SUM(
    CASE
        WHEN Year = 2022 THEN Value
        ELSE 0
    END
) AS Production_2022
```

From there, I calculated the change:

```text
Change = Production_2022 - Production_2021
```

I then used the same results to calculate percentage change and identify the states with the largest increases and decreases.

This was also where I started using **CTEs** to break larger calculations into separate steps instead of trying to do everything in one massive query.

### 3. Comparing commodities

The next step was to stop looking at each commodity completely on its own.

I created separate CTEs for commodities such as milk and cheese, calculated their changes, and then joined the results together.

For example:

```text
State | Milk_Change | Cheese_Change | Growth_Leader
```

I also brought milk, cheese, and yogurt together at the state level and used the results to compare their recorded production values.

One thing I had to be careful about here was joining the raw production tables directly. Doing that before aggregation can multiply rows and give incorrect totals, so I aggregated each commodity first and joined the results afterward.

### 4. Production Share and State Profiles

The later queries look at production from two different perspectives.

First, I calculated each state's percentage of total U.S. production for individual commodities and compared those shares between 2021 and 2022. This is useful because production growth and production share aren't necessarily the same thing. A state can increase its own production while still losing some of its share of total U.S. production.

I then created a state-level production profile by bringing several commodities together:

State
Milk
Cheese
Yogurt
Eggs
Honey
Coffee
Highest_Production_Commodity

This final profile uses multiple CTEs to combine the commodity data, while `COALESCE` handles missing values and `CASE` identifies the commodity with the highest recorded value.

---

## SQL concepts I used

The project gave me a chance to work with a lot more than basic querying.

### Core SQL

* `SELECT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* Aliases
* Aggregate functions

### Aggregation

* `SUM()`
* Conditional aggregation
* Aggregating by state
* Aggregating by year

### Joins

* `INNER JOIN`
* Joining production tables with lookup tables
* Joining aggregated CTEs
* `CROSS JOIN`

### Conditional logic

* `CASE`
* Year-based calculations
* Growth comparisons
* Identifying the highest recorded production value
* Custom sorting

### CTEs

I used Common Table Expressions to split larger analytical problems into smaller steps.

Instead of trying to calculate everything in one query, I could create a temporary result, give it a name, and then use that result in the next part of the query.

That ended up being one of the most useful concepts in the project.

---

## Data quality considerations

There are a few things worth keeping in mind when working with this data.

### Reporting periods

Annual analysis needs to use the annual records specifically. Otherwise, monthly and annual observations could be mixed together.

### Missing data

Not every state has production data for every commodity.

A missing value doesn't automatically mean that production was zero, so I kept missing data separate from actual zero values where appropriate.

### State identifiers

The production tables use `State_ANSI`, while the lookup table provides the corresponding state name.

### Different commodities

Production values for different commodities shouldn't automatically be added together or used to create one overall production score.

The commodities can use different units and scales, so combining them without checking the underlying measurements would create a misleading comparison.

---

## Project structure

```text
USDA-Agricultural-Production-SQL/
│
├── README.md
│
├── SQL/
│   ├── 01_...
│   ├── 02_...
│   └── ...
│
├── data/
│   └── README.md
│
└── Results/
    ├── README.md
    ├── 07_...
    ├── 11_...
    └── ...
```

The SQL files are organized in the same general order as the analysis, starting with basic production queries and moving toward the more advanced comparisons.

---

## What I learned

The biggest thing I got from this project was learning how to build a query in stages.

At the beginning, most of the work was straightforward aggregation. As the questions became more specific, I had to think more carefully about things like:

* When to aggregate before joining
* How `CASE` can be used inside aggregate functions
* Why aliases can't always be reused in the same `SELECT`
* When a CTE makes a query easier to understand
* How to calculate percentage changes safely
* How to compare multiple datasets without accidentally changing the underlying totals

The project also made it pretty clear that writing SQL that *runs* and writing SQL that produces the **right analysis** are two different things.

---

## Key Findings

A few results stood out from the analysis:

* **Texas had the largest increase in milk production** between 2021 and 2022, increasing by **925 million**.
* **New Mexico had the largest decrease in milk production**, declining by **656 million** over the same period.
* **Iowa had the largest increase in cheese production**, with production increasing by **46.293 million** from 2021 to 2022.
* Iowa also had the **highest percentage increase in cheese production at 13.47%**, followed by Illinois at 5.78%.
* **Wisconsin accounted for 25.03% of the cheese production share** in the 2022 analysis, making it the largest state in that comparison.
* **California accounted for 18.45% of milk production and 32.26% of yogurt production** in the corresponding 2022 share analysis.
* **North Dakota accounted for 24.89% of honey production**, the largest share in the honey results.

The results also show why looking at both absolute change and percentage change is useful. Iowa's cheese increase was the largest in absolute terms as well as percentage terms, while other states had much smaller changes that looked more significant when expressed as a percentage.

The full outputs are available in the [`Results`](./Results/) folder, while the SQL used to produce them is available in the [`SQL`](./SQL/) folder.

### Selected Results

* [Milk Production Change — 2021 to 2022](./Results/07_Milk_Production_Change_2021_2022.csv)
* [States with Cheese Production Increases](./Results/11_States_with_Cheese_Production_Increases.csv)
* [Cheese Percentage Change by State](./Results/13_Cheese_Percentage_Change_by_State.csv)
* [Milk, Cheese & Yogurt Comparison](./Results/15_Milk_Cheese_Yogurt_Comparison_by_State.csv)
* [Cheese vs. Milk Production Change](./Results/16_Cheese_vs_Milk_Production_Change_2021_2022.csv)
* [State Production Profile](./Results/17_State_Multi_Commodity_Production_Profile.csv)
* [Production Share Analysis](./Results/18_Capstone_Production_Share_Analysis.csv)


---

## Future improvements

There are a few directions I could take the project from here:

* Add more years to look at longer-term trends
* Add more commodities
* Create visualizations from the SQL results
* Build a dashboard using the final datasets
* Add more automated data-quality checks
* Document the original USDA source files and units in more detail

---

## Tools

* SQL
* Relational database
* USDA agricultural production data
* GitHub

---

## About

I'm a student building my data analytics skills through projects that involve working with real datasets and answering practical questions with SQL.

This project is part of that process, with the focus being on understanding the data and building the analysis myself rather than just producing a collection of SQL queries.

---

### Disclaimer

This is an independent analysis of USDA agricultural production data for educational and portfolio purposes. It is not an official USDA publication.
