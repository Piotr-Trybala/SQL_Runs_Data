DROP DATABASE IF EXISTS runs_data;
CREATE DATABASE IF NOT EXISTS runs_data CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';
SHOW DATABASES;
USE runs_data;
CREATE TABLE runs (
	run_id INT AUTO_INCREMENT PRIMARY KEY,
    run_date DATE NOT NULL,
    run_type ENUM('Sprint series', 'Easy run', 'Progressive run') NOT NULL,
    total_distance_km DECIMAL(5,2),
    total_time TIME
    );
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
SELECT * FROM segments;
SELECT * FROM runs;

SELECT segment_type,AVG(avg_pace)
FROM segments
GROUP BY segment_type
;

SELECT COUNT(run_id), run_type
	FROM runs
    WHERE total_distance_km > 10
    GROUP BY run_type
    ;

SELECT r.run_type, AVG(s.avg_pace)
	FROM runs AS r
    LEFT JOIN segments AS s
    USING (run_id)
    GROUP BY r.run_type
    ;
    
    
    ;

SELECT segment_type, SEC_TO_TIME(AVG(TIME_TO_SEC(avg_pace)))
FROM segments
GROUP BY segment_type
;

SELECT segment_type, SEC_TO_TIME(AVG(TIME_TO_SEC(avg_pace)))
FROM segments
GROUP BY segment_type
;