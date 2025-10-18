# 🏃‍♂️‍➡️ Runs database in SQL

## 📝 Description
This project focuses on analyzing my personal running data collected from sports watch during half-marathon training. Data is transformed into a SQL database consisting of two tables, which together can be used for detailed performance analysis.

This project includes **`data cleaning`**, **`database creation`** and **`exploratory analysis`** through SQL queries designed to provide insights into training progress, strategy and consistency. 

---

## 📊 Data
The dataset contains detailed information on **32 running sessions** divided into three distinct run types. Each run is further broken down into segments, allowing for a more accurate and dynamic analysis. Data is divided into 2 tables:

- **`runs`** - provides basic information about each training session: date, time, distance and run type (*Easy run, Sprint series, Progressive run*)
- **`segments`** - contains detailed information about each segment within a run including segment type (*Warmup, Slow run, Fast run, Run, Sprint, Rest, Cooldown*), segment lenght and performance statistics 

---

## 🎯 Goal

The main goal of this project is to transform raw running data collected from a Garmin watch into a structured SQL database that enables detailed analysis. Table **`runs`** captures summary metrics of each workout, while table **`segments`** provides a detailed breakdown of each session into it's individual components. This structure allows both macro (long-term progress) and micro (intra-session performance) analysis. Through this approach, it becomes possible to:
- **track progress** - evaluate improvement in pace, endurance and heart rate across training sessions and training segments, 
- **analyse training structure** - explore the distribution of run types and how training intensity ecolved closed to race day,
- **assess consistency** - determine how systematically the entire training plan was executed and identify periods of high or low engagement.

---

## 🚀 Program Walk-through

### 1. First look into data
*`runs table`*

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/2ae4724b48aa742d0eed65e6c6b2977cef1319e6/Screenshots/runs.png)

*`segments table`*

![image_alt](https://github.com/Piotr-Trybala/SQL_Runs_Data/blob/2ae4724b48aa742d0eed65e6c6b2977cef1319e6/Screenshots/segments.png)

---

### 2. Creating *`runs_data*` database
<p align="center">
  <img src="https://i.imgur.com/FPsfjMy.png" alt="XLOOKUP Example" width="600"/>
</p>

Or using **INDEX + MATCH**:
<p align="center">
  <img src="https://i.imgur.com/CfB2au0.png" alt="INDEX Formula" width="600"/>
</p>

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
