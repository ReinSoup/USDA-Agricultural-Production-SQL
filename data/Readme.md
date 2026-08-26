# Data

This folder contains documentation related to the datasets used in the USDA Agricultural Production SQL project.

## Data Source

The project uses USDA agricultural production data organized into separate tables by commodity, along with a state lookup table.

The commodities used in the analysis include:

* Milk
* Cheese
* Yogurt
* Eggs
* Honey
* Coffee

The production tables contain fields such as:

| Field        | Description                                                                   |
| ------------ | ----------------------------------------------------------------------------- |
| `State_ANSI` | State identifier used to connect production records to the state lookup table |
| `Year`       | Reporting year                                                                |
| `Period`     | Reporting period                                                              |
| `Value`      | Reported production value                                                     |

The `state_lookup` table is used to match `State_ANSI` values with state names.

## Annual Data

For analyses involving yearly production, the SQL queries filter the data using:

```sql
WHERE Period = 'YEAR'
```

This prevents monthly and annual records from being combined and overstating production totals.

## Data Handling

Not every state has production records for every commodity. Missing data is therefore kept distinct from an actual production value of zero.

The production values for different commodities are also not automatically combined into one overall score, since their units and scales may differ.

## Source

**U.S. Department of Agriculture (USDA)**

The exact USDA dataset names and original download links will be documented here once the source files are finalized.

## Notes

The data is used for educational and portfolio purposes. The analysis in this repository is independent and is not an official USDA statistical publication.
