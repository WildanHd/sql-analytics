# SQL Analytics Pipeline

A collection of SQL queries and tools to perform some of analysis I did in my previous projects

## Several projects

- Event tracking and normalization
- User journey classification
- Conversion funnel mapping
- Clean and optimized SQL structure
- Notebook-ready for exploration

## Folder Structure

- `queries/`: SQL files for core logic (e.g., journey, conversion)
- `notebooks/`: Optional Jupyter notebooks for EDA and visualization
- `.gitignore`, `LICENSE`, `README.md`: Project metadata

## Example Query: `user_journey.sql`

Classifies raw events into labeled journey stages for easy funnel visualization.

```sql
SELECT timestamp, fingerprint, user_id,
       CASE
           WHEN action = 'read' AND name = 'detail_article' THEN 'b_reach'
           ...
           ELSE 'a_others'
       END AS journey
FROM ...
