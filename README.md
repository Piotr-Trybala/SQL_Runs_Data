# 🏃‍♂️‍➡️ Runs database in SQL

## 📝 Description
This project focuses on analyzing my personal running data collected from sports watch during half-marathon training. Data is transformed into a SQL database consisting of two tables, which together can be used for detailed performance analysis.

This project includes **`data cleaning`**, **`database creation`** and **`exploratory analysis`** through SQL queries designed to provide insights into training progress, strategy and consistency. 

---

## 📊 Data
The dataset contains detailed information on **32 running sessions** divided into three distinct run types. Each run is further broken down into segments, allowing for a more accurate and dynamic analysis. Data is divided into 2 tables:

- **`runs`** - provides basic information about each training session: date, time, distance and run type (*Easy run, Sprint series, Progressive run*)
- **`segments`** - contains detailed information about each segment within a run including segment type, **468 observations** (*Warmup, Slow run, Fast run, Run, Sprint, Rest, Cooldown*), segment lenght and performance statistics 

---

## 🎯 Goal

The main goal of this project is to transform raw running data collected from a Garmin watch into a structured SQL database that enables detailed analysis. Table **`runs`** captures summary metrics of each workout, while table **`segments`** provides a detailed breakdown of each session into its individual components. This structure allows both macro (long-term progress) and micro (intra-session performance) analysis. Through this approach, it becomes possible to:
- **track progress** - evaluate improvement in pace, endurance and heart rate across training sessions and training segments, 
- **analyse training structure** - explore the distribution of run types and how training intensity evolved closed to race day,
- **assess consistency** - determine how systematically the entire training plan was executed and identify periods of high or low engagement.

---

## 🚀 Program Walk-through

### 1. First look into data
*`runs`* table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/2ae4724b48aa742d0eed65e6c6b2977cef1319e6/Screenshots/runs.png)

*`segments`* table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/2ae4724b48aa742d0eed65e6c6b2977cef1319e6/Screenshots/segments.png)

---

### 2. Creating *`runs_data`* database

```sql
DROP DATABASE IF EXISTS runs_data;
CREATE DATABASE IF NOT EXISTS runs_data
	CHARACTER SET 'utf8mb4' 
	COLLATE 'utf8mb4_unicode_ci';
SHOW DATABASES;
USE runs_data;
```
#### 2.1 Creating *`runs`* table
```sql
CREATE TABLE runs (
	run_id INT AUTO_INCREMENT PRIMARY KEY,
    run_date DATE NOT NULL,
    run_type ENUM('Sprint series', 'Easy run', 'Progressive run') NOT NULL,
    total_distance_km DECIMAL(5,2),
    total_time TIME
	);
```
Filling the data manually into the table.
```sql
INSERT INTO runs (run_date, run_type, total_distance_km, total_time)
VALUES 
	(STR_TO_DATE('26.06.2025', '%d.%m.%Y'), 'Sprint series', 5.400, '00:40:38'),
	(STR_TO_DATE('30.06.2025', '%d.%m.%Y'), 'Easy run', 6.370, '00:40:00'),
	...
	(STR_TO_DATE('12.10.2025', '%d.%m.%Y'), 'Easy run', 21.310, '01:57:09');
```
#### 2.2 Creating *`segments`* table
```sql
CREATE TABLE segments (
	segment_id INT AUTO_INCREMENT PRIMARY KEY,
    run_id INT,
    segment_number INT,
    segment_type ENUM('Cooldown', 'Fast run', 'Rest', 'Run', 'Slow run', 'Sprint', 'Warmup') NOT NULL,
    segment_distance DECIMAL(5,2),
    segment_time TIME,
    avg_pace TIME,
    avg_hr INT,
    max_he INT,
    FOREIGN KEY (run_id) REFERENCES runs(run_id)
	);
```
Filling the data into segments table using Table Data Import Wizard.

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/2aee9ed4ffcbaaeb73056ad286c9dae6ccee2ea4/Screenshots/Import%20wizard.png)

---

#### 2.3 Overview of created tables

*`runs`* table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/63a8bd1e4d6bf7b994bb1208c366d147381a63eb/Screenshots/runs_table_overview.png)

*`segments`* table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/63a8bd1e4d6bf7b994bb1208c366d147381a63eb/Screenshots/segments_table_overview.png)

Testing aggregate functions on time-based columns:

```sql
SELECT segment_type,AVG(avg_pace)																	
FROM segments
GROUP BY segment_type;
```
![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/3d341610b5d2233c0b01f1059c0a37c5750556b9/Screenshots/type_time_avg.png)

There are few issues with data:
- **`total_time`** column - data type is *TIME* which can cause issues with aggregate functions (**`runs`** table)
- **`max_he`** column - typo in column name, max_he instead of max_hr (**`segments`** table)
- **`segment_time`** and **`avg_pace`** columns - wrong *TIME* format, seconds are taken as minutes and minutes as hours (**`segments`** table)
- **`segment_time`** and **`avg_pace`** columns - data type is *TIME* which can cause issues with aggregate functions (**`seconds`** table)

---

#### 2.4 Data cleaning 

##### Add column for total time in seconds (*`runs`* table) 

```sql
ALTER TABLE runs
	ADD COLUMN total_time_sec INT AFTER total_time;
UPDATE runs
SET 
	total_time_sec = TIME_TO_SEC(total_time);
```
---

##### Correct typo in column name (*`segments`* table)

```sql
ALTER TABLE segments 
	RENAME COLUMN max_he TO max_hr;
```

##### Correct wrong TIME format before converting into seconds (*`segments`* table)

The *`segment_time`* and *`avg_pace`* columns were imported in incorrect format - seconds were interpreted as minutes and minutes as hours. To fix this, we create new columns using the *`MAKETIME()`* function with *`HOUR`* and *`MINUTE`* as arguments. But first, we need to check for odd results in incorrectly imported data to make sure that functions are applicable.

```sql
SELECT MAX(segment_time), MAX(avg_pace)
FROM segments;
```
![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/c4edf9b01cda3db862e7bf537f72ec7a2975267b/Screenshots/MAXs.png)

Since no value exceeds 60 hours, we can safely apply the transformation.

```sql
ALTER TABLE segments																				
	ADD COLUMN segment_time_fixed TIME AFTER segment_time,
    ADD COLUMN avg_pace_fixed TIME AFTER avg_pace;
```
Fill the new columns with corrected values using *`MAKETIME`* functions

```sql
UPDATE segments
SET
	segment_time_fixed = MAKETIME(0, HOUR(segment_time), MINUTE(segment_time)),
    avg_pace_fixed = MAKETIME(0, HOUR(avg_pace), MINUTE(avg_pace));
```

##### Convert TIME to seconds (INT)

```sql
ALTER TABLE segments																				
	ADD COLUMN segment_time_sec INT AFTER segment_time_fixed,
    ADD COLUMN avg_pace_sec INT AFTER avg_pace_fixed;
UPDATE segments
SET 
	segment_time_sec = TIME_TO_SEC(segment_time_fixed),
	avg_pace_sec = TIME_TO_SEC(avg_pace_fixed);
```
---
##### Overview of the tables after Data Cleaning

*`runs`* table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/7768d21c0555f4f12f081aa0b75fe7c6de6f4693/Screenshots/runs_updated.png)

*`segments`* table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/7768d21c0555f4f12f081aa0b75fe7c6de6f4693/Screenshots/segments_updated.png)

Testing aggregate functions on new columns:

```sql
SELECT 																								
	segment_type, 
    ROUND(AVG(avg_pace_sec),2) AS avg_pace_sec, 		
	SEC_TO_TIME(ROUND(AVG(avg_pace_sec))) AS avg_pace_formatted
FROM segments
GROUP BY segment_type;
```
![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/478b5825cc5f526d496304bfd39e0a66802c03de/Screenshots/aggregate_functions_new.png)

---
### 3. SQL Exploratory Analysis

#### 3.1 How many runs of each type were completed during training period?

```sql
SELECT 
	run_type, 
    COUNT(*) AS number_of_runs																		
FROM runs
GROUP BY run_type
ORDER BY number_of_runs DESC;
```

#### 3.2 What is the average distance and duration for each run type?

```sql
SELECT			
	run_type,
    ROUND(AVG(total_distance_km),2) AS average_distance,
    SEC_TO_TIME(ROUND(AVG(total_time_sec))) AS average_duration
FROM runs
GROUP BY run_type
ORDER BY average_distance DESC;
```

#### 3.3 Which runs were the longest?

```sql
SELECT																								
	run_date,
	run_type,
    total_distance_km,
    total_time
FROM runs
ORDER BY total_distance_km DESC
LIMIT 5; 
```

#### 3.4 What is the average and maximum heart rate for each run type?

```sql
SELECT																								
	r.run_type,
    ROUND(AVG(s.avg_hr)) AS avg_hr,
    MAX(s.max_hr) AS max_hr
FROM runs AS r
JOIN segments AS s
USING (run_id)
GROUP BY run_type;
```

#### 3.5 Which weeks had the highest total training volume?

```sql
SELECT																								
	1+FLOOR(DATEDIFF(run_date, (SELECT MIN(run_date) FROM runs))/7) AS training_week,
    COUNT(*) AS total_runs
FROM runs
GROUP BY training_week;
```

#### 3.6 What is the average pace per segment type and to which run_type it belongs?

```sql
SELECT																								
	r.run_type,
    s.segment_type,
    SEC_TO_TIME(ROUND(AVG(s.avg_pace_sec))) AS average_pace,
    ROUND(AVG(s.avg_hr)) AS average_heart_rate
FROM runs AS r
JOIN segments AS s
USING (run_id)
GROUP BY r.run_type, segment_type;
```

#### 3.7 How average pace of segment type 'Run' evolved during each of Easy runs?

```sql
SELECT 				
	run_id,
    s.segment_type,
    s.segment_distance,
    SEC_TO_TIME(s.avg_pace_sec) AS pace_per_segment,
    SEC_TO_TIME(ROUND(AVG(s.avg_pace_sec) OVER(
		PARTITION BY run_id))) AS avg_segment_pace
FROM runs AS r
JOIN segments AS s
USING (run_id)
WHERE s.segment_type = 'Run'
;
```

#### 3.8 How many runs in Easy runs were 'Long runs' (over 15 km), 'Short runs' (7-15 km) and 'Recovery runs' (<7 km)?

```sql
SELECT	
	CASE WHEN total_distance_km < 7 THEN 'Recovery run'
		WHEN total_distance_km BETWEEN 7 AND 14 THEN 'Short run'
        ELSE 'Long run' 
	END AS run_lenth_category,
    COUNT(*)
FROM runs
WHERE run_type = 'Easy run'
GROUP BY run_lenth_category
;
```

#### 3.9 Which runs were faster than the overall average?

```sql
SELECT	
	*,
    SEC_TO_TIME(ROUND(total_time_sec/total_distance_km)) AS avg_run_pace,
    SEC_TO_TIME(
		ROUND((SELECT SUM(total_time_sec)/SUM(total_distance_km) 
		FROM runs))) AS overall_average_pace
FROM runs 
WHERE (total_time_sec/total_distance_km) < (
	SELECT SUM(total_time_sec)/SUM(total_distance_km)
    FROM runs
    )
;
```
---


---

## 💡 Key Skills Demonstrated
- Excel formulas: `XLOOKUP`, `INDEX`, `MATCH`
- Data cleaning and transformation
- Pivot Tables & Charts
- Dashboard design and interactivity
- Layout formatting and presentation
