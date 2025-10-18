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

The main goal of this project is to transform raw running data collected from a Garmin watch into a structured SQL database that enables detailed analysis. Table **`runs`** captures summary metrics of each workout, while table **`segments`** provides a detailed breakdown of each session into it's individual components. This structure allows both macro (long-term progress) and micro (intra-session performance) analysis. Through this approach, it becomes possible to:
- **track progress** - evaluate improvement in pace, endurance and heart rate across training sessions and training segments, 
- **analyse training structure** - explore the distribution of run types and how training intensity ecolved closed to race day,
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
CREATE DATABASE IF NOT EXISTS runs_data CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';
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
    total_time TIME);
```
Filling the data manually into the table
```sql
INSERT INTO runs (run_date, run_type, total_distance_km, total_time)
VALUES 
	(STR_TO_DATE('26.06.2025', '%d.%m.%Y'), 'Sprint series', 5.400, '00:40:38'),
	(STR_TO_DATE('30.06.2025', '%d.%m.%Y'), 'Easy run', 6.370, '00:40:00'),
	(STR_TO_DATE('02.07.2025', '%d.%m.%Y'), 'Sprint series', 6.060, '00:38:39'),
	(STR_TO_DATE('03.07.2025', '%d.%m.%Y'), 'Easy run', 8.090, '00:53:58'),
	(STR_TO_DATE('09.07.2025', '%d.%m.%Y'), 'Easy run', 4.340, '00:30:00'),
	(STR_TO_DATE('10.07.2025', '%d.%m.%Y'), 'Easy run', 5.420, '00:29:57'),
	(STR_TO_DATE('12.07.2025', '%d.%m.%Y'), 'Easy run', 4.200, '00:30:00'),
	(STR_TO_DATE('16.07.2025', '%d.%m.%Y'), 'Sprint series', 6.460, '00:40:48'),
	(STR_TO_DATE('17.07.2025', '%d.%m.%Y'), 'Progressive run', 6.250, '00:39:58'),
	(STR_TO_DATE('21.07.2025', '%d.%m.%Y'), 'Easy run', 8.900, '01:00:00'),
	(STR_TO_DATE('24.07.2025', '%d.%m.%Y'), 'Progressive run', 7.320, '00:45:01'),
	(STR_TO_DATE('26.07.2025', '%d.%m.%Y'), 'Sprint series', 6.010, '00:40:50'),
	(STR_TO_DATE('27.07.2025', '%d.%m.%Y'), 'Easy run', 11.170, '01:19:59'),
	(STR_TO_DATE('29.07.2025', '%d.%m.%Y'), 'Sprint series', 6.160, '00:40:50'),
	(STR_TO_DATE('31.07.2025', '%d.%m.%Y'), 'Progressive run', 7.860, '00:50:00'),
	(STR_TO_DATE('03.08.2025', '%d.%m.%Y'), 'Easy run', 12.730, '01:30:00'),
	(STR_TO_DATE('04.08.2025', '%d.%m.%Y'), 'Easy run', 7.730, '00:50:05'),
	(STR_TO_DATE('06.08.2025', '%d.%m.%Y'), 'Easy run', 8.270, '00:50:01'),
	(STR_TO_DATE('17.08.2025', '%d.%m.%Y'), 'Easy run', 16.620, '01:41:29'),
	(STR_TO_DATE('26.08.2025', '%d.%m.%Y'), 'Sprint series', 5.720, '00:40:50'),
	(STR_TO_DATE('28.08.2025', '%d.%m.%Y'), 'Progressive run', 7.940, '01:00:01'),
	(STR_TO_DATE('31.08.2025', '%d.%m.%Y'), 'Easy run', 19.970, '02:04:36'),
	(STR_TO_DATE('02.09.2025', '%d.%m.%Y'), 'Easy run', 5.450, '00:48:51'),
	(STR_TO_DATE('04.09.2025', '%d.%m.%Y'), 'Easy run', 6.090, '00:50:01'),
	(STR_TO_DATE('12.09.2025', '%d.%m.%Y'), 'Sprint series', 5.740, '00:40:50'),
	(STR_TO_DATE('15.09.2025', '%d.%m.%Y'), 'Easy run', 16.280, '01:45:00'),
	(STR_TO_DATE('24.09.2025', '%d.%m.%Y'), 'Sprint series', 5.190, '00:38:39'),
	(STR_TO_DATE('26.09.2025', '%d.%m.%Y'), 'Progressive run', 6.650, '00:40:01'),
	(STR_TO_DATE('29.09.2025', '%d.%m.%Y'), 'Sprint series', 5.330, '00:37:53'),
	(STR_TO_DATE('02.10.2025', '%d.%m.%Y'), 'Progressive run', 9.670, '01:00:00'),
	(STR_TO_DATE('03.10.2025', '%d.%m.%Y'), 'Easy run', 16.100, '01:40:03'),
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
    FOREIGN KEY (run_id) REFERENCES runs(run_id));
```
Filling the data into segments table using Table Data Import Wizard

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/2aee9ed4ffcbaaeb73056ad286c9dae6ccee2ea4/Screenshots/Import%20wizard.png)

---

#### 2.3 Overview of created tables

*`runs`*  table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/63a8bd1e4d6bf7b994bb1208c366d147381a63eb/Screenshots/runs_table_overview.png)

*`segments`* table

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/63a8bd1e4d6bf7b994bb1208c366d147381a63eb/Screenshots/segments_table_overview.png)

There are few issues with data:
- **`total_time`** column - data type is *TIME* which can cause issues with aggregate functions (**`runs`** table)
- **`max_he`** column - typo in column name, max_he instead of max_hr (**`segments`** table)
- **`segment_time`** and **`avg_pace`** columns - wrong *TIME* format, seconds are taken as minutes and minutes as hours (**`segments`** table)
- **`segment_time`** and **`avg_pace`** columns - data type is *TIME* which can cause issues with aggregate functions (**`seconds`** table)

---

#### 2.4 Data cleaning 




##### Correcting a typo in column name in *`segments`* table

```sql
ALTER TABLE segments RENAME COLUMN max_he TO max_hr;
```
##### Checking and changing type of columns containing time values 

Creating a query to see the results of aggregated functions on columns of the `time` type

```sql
SELECT segment_type,AVG(avg_pace)
FROM segments
GROUP BY segment_type;
```
![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/3d341610b5d2233c0b01f1059c0a37c5750556b9/Screenshots/type_time_avg.png)







---
### 3. Creating Pivot Tables
Used for **quick analysis** and as data sources for charts.
<p align="center">
  <img src="https://i.imgur.com/aGcUcLP.png" alt="Pivot Tables" width="600"/>
</p>

---

### 4. Building an Interactive Dashboard
Includes:
- Custom **Timeline Layout**
- **Category Filters**
- Dynamic charts
<p align="center">
  <img src="https://i.imgur.com/koLnWEj.png" alt="Dashboard Example" width="600"/>
</p>

Filtered dashboard view:
<p align="center">
  <img src="https://i.imgur.com/oeVXwlY.png" alt="Filtered Dashboard" width="600"/>
</p>

---

## 💡 Key Skills Demonstrated
- Excel formulas: `XLOOKUP`, `INDEX`, `MATCH`
- Data cleaning and transformation
- Pivot Tables & Charts
- Dashboard design and interactivity
- Layout formatting and presentation
