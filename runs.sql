DROP DATABASE IF EXISTS runs_data; 																	#Creating a table#
CREATE DATABASE IF NOT EXISTS runs_data 
	CHARACTER SET 'utf8mb4' 
    COLLATE 'utf8mb4_unicode_ci';
SHOW DATABASES;
USE runs_data;
CREATE TABLE runs (																					#Creating runs table
	run_id INT AUTO_INCREMENT PRIMARY KEY,
    run_date DATE NOT NULL,
    run_type ENUM('Sprint series', 'Easy run', 'Progressive run') NOT NULL,
    total_distance_km DECIMAL(5,2),
    total_time TIME
    );    
INSERT INTO runs (run_date, run_type, total_distance_km, total_time)    							#Inserting values into runs table
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
CREATE TABLE segments (																				#Creating segments table
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
SELECT * FROM runs;    
SELECT * FROM segments;
SELECT segment_type,AVG(avg_pace)																	#Checking aggregations on TIME format columns
FROM segments
GROUP BY segment_type;

#Data cleaning
ALTER TABLE runs																					#Adding column with number of secons instead of minutes in TIME format 
	ADD COLUMN total_time_sec INT AFTER total_time;
UPDATE runs
SET 
	total_time_sec = TIME_TO_SEC(total_time);

ALTER TABLE segments 
	RENAME COLUMN max_he TO max_hr;												#Renaming column

SELECT MAX(segment_time), MAX(avg_pace)																#MAX check
FROM segments;
ALTER TABLE segments																				#Adding fixed columns
	ADD COLUMN segment_time_fixed TIME AFTER segment_time,
    ADD COLUMN avg_pace_fixed TIME AFTER avg_pace;
UPDATE segments
SET
	segment_time_fixed = MAKETIME(0, HOUR(segment_time), MINUTE(segment_time)),
    avg_pace_fixed = MAKETIME(0, HOUR(avg_pace), MINUTE(avg_pace));
ALTER TABLE segments																				#Adding column that changes TIME to INT
	ADD COLUMN segment_time_sec INT AFTER segment_time_fixed,
    ADD COLUMN avg_pace_sec INT AFTER avg_pace_fixed;
UPDATE segments
SET 
	segment_time_sec = TIME_TO_SEC(segment_time_fixed),
	avg_pace_sec = TIME_TO_SEC(avg_pace_fixed);
SELECT * FROM runs;
SELECT * FROM segments;
SELECT 																								#Checking aggregations on new column
	segment_type, 
    ROUND(AVG(avg_pace_sec),2) AS avg_pace_sec, 		
	SEC_TO_TIME(ROUND(AVG(avg_pace_sec))) AS avg_pace_formatted
FROM segments
GROUP BY segment_type;

#Exploratory Analysis

SELECT 																								#How many runs of each type were completed during training period?
	run_type, 
    COUNT(*) AS number_of_runs																		
FROM runs
GROUP BY run_type
ORDER BY number_of_runs DESC;

SELECT																								#What is the average distance and duration for each run type?
	run_type,
    ROUND(AVG(total_distance_km),2) AS average_distance,
    SEC_TO_TIME(ROUND(AVG(total_time_sec))) AS average_duration
FROM runs
GROUP BY run_type
ORDER BY average_distance DESC;

SELECT																								#Which runs were the longest?
	run_id,
	run_date,
	run_type,
    total_distance_km,
    total_time
FROM runs
ORDER BY total_distance_km DESC
LIMIT 5; 

SELECT																								#What is the average and maximum heart rate for each run type?
	r.run_type,
    ROUND(AVG(s.avg_hr)) AS avg_hr,
    MAX(s.max_hr) AS max_hr
FROM runs AS r
JOIN segments AS s
USING (run_id)
GROUP BY run_type;

 SELECT																								#Which weeks had the highest total training volume?
	1+FLOOR(DATEDIFF(run_date, (SELECT MIN(run_date) FROM runs))/7) AS training_week,
    COUNT(*) AS total_runs
FROM runs
GROUP BY training_week;

SELECT																								#What is the average pace per segment type and to which run_type it belongs?
	r.run_type,
    s.segment_type,
    SEC_TO_TIME(ROUND(AVG(s.avg_pace_sec))) AS average_pace,
    ROUND(AVG(s.avg_hr)) AS average_heart_rate
FROM runs AS r
JOIN segments AS s
USING (run_id)
GROUP BY r.run_type, segment_type;

SELECT 																								#How average pace of segment type 'Run' evolved during each of Easy runs?						
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

SELECT																								#How many runs in Easy runs were 'Long runs' (over 15 km), 'Short runs' (7-15 km) and 'Recovery runs' (<7 km)
	CASE WHEN total_distance_km < 7 THEN 'Recovery run'
		WHEN total_distance_km BETWEEN 7 AND 14 THEN 'Short run'
        ELSE 'Long run' 
	END AS run_lenth_category,
    COUNT(*)
FROM runs
WHERE run_type = 'Easy run'
GROUP BY run_lenth_category
;

SELECT																								#Which runs were faster than the overall average?
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



