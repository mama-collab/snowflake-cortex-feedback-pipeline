-- STEP 1: Create database and schema
CREATE DATABASE IF NOT EXISTS FEEDBACK_INTELLIGENCE;
USE DATABASE FEEDBACK_INTELLIGENCE;

CREATE SCHEMA IF NOT EXISTS RAW;
USE SCHEMA RAW;

-- STEP 2: Create the feedback table
CREATE OR REPLACE TABLE CUSTOMER_FEEDBACK (
    FEEDBACK_ID     NUMBER AUTOINCREMENT PRIMARY KEY,
    CUSTOMER_NAME   VARCHAR(100),
    PRODUCT         VARCHAR(100),
    FEEDBACK_TEXT   VARCHAR(2000),
    RATING          NUMBER(2,1),   -- e.g. 4.5
    SUBMITTED_DATE  DATE,
    COUNTRY         VARCHAR(50)
);

-- STEP 3: Insert 20  sample rows
INSERT INTO CUSTOMER_FEEDBACK 
    (CUSTOMER_NAME, PRODUCT, FEEDBACK_TEXT, RATING, SUBMITTED_DATE, COUNTRY)
VALUES
('Aisha Patel',      'DataSync Pro',   'Absolutely love the new dashboard. Setup was a breeze and the real-time sync saved us hours every week.', 5.0, '2026-05-01', 'Canada'),
('James Liu',        'DataSync Pro',   'Good product overall but the onboarding docs are confusing. Took us 3 days to get going.', 3.0, '2026-05-03', 'USA'),
('Maria Santos',     'CloudETL Basic', 'It crashed twice during our first migration. Support took 48 hours to respond. Very frustrated.', 1.5, '2026-05-05', 'Brazil'),
('Liam Novak',       'CloudETL Pro',   'Exceptional performance. We moved 10TB in under an hour. The team is amazed.', 5.0, '2026-05-07', 'Germany'),
('Sophie Turner',    'DataSync Pro',   'Works well but pricing feels steep for small teams. Would love a startup tier.', 3.5, '2026-05-09', 'UK'),
('Raj Mehta',        'CloudETL Basic', 'The scheduler is unreliable. Jobs fail silently and there is no alerting built in.', 2.0, '2026-05-11', 'India'),
('Emily Chen',       'DataSync Pro',   'Customer support team is incredible. Resolved my issue in under an hour. 10 out of 10.', 5.0, '2026-05-13', 'Canada'),
('Carlos Rivera',    'CloudETL Pro',   'Solid product but the UI feels outdated. Functionality is great though.', 3.5, '2026-05-15', 'Mexico'),
('Priya Sharma',     'DataSync Pro',   'This tool transformed how we handle data. The AI features are a game changer for our analysts.', 5.0, '2026-05-17', 'Canada'),
('Noah Kim',         'CloudETL Basic', 'Too many bugs in the CSV import. Half our files fail with no clear error message.', 2.0, '2026-05-19', 'South Korea'),
('Fatima Al-Sayed',  'DataSync Pro',   'Very easy to configure. Our non-technical team picked it up in one afternoon.', 4.5, '2026-05-21', 'UAE'),
('Ben Carter',       'CloudETL Pro',   'Best ETL tool we have used in 10 years. Handles our complex pipelines without breaking a sweat.', 5.0, '2026-05-23', 'Australia'),
('Yuki Tanaka',      'DataSync Pro',   'The mobile app is very limited compared to desktop. Please improve it.', 3.0, '2026-05-25', 'Japan'),
('Olu Adeyemi',      'CloudETL Basic', 'Good value for money. Not perfect but does the job for our small team.', 3.5, '2026-05-27', 'Nigeria'),
('Sara Johnson',     'CloudETL Pro',   'Had a great experience until the pricing doubled at renewal. Feels like a bait and switch.', 2.5, '2026-05-29', 'USA'),
('Dmitri Volkov',    'DataSync Pro',   'Incredible reliability. Zero downtime in 6 months of heavy use. Truly enterprise-grade.', 5.0, '2026-06-01', 'Russia'),
('Amara Diallo',     'CloudETL Basic', 'The API documentation is excellent. Integrated with our stack in one day.', 4.0, '2026-06-03', 'Senegal'),
('Grace Wu',         'DataSync Pro',   'Love the product but wish there were more regional data centres. Latency is noticeable from Asia.', 3.5, '2026-06-05', 'Singapore'),
('Tom O\'Brien',     'CloudETL Pro',   'Support team went above and beyond. They hopped on a call at midnight to help us fix a critical issue.', 5.0, '2026-06-07', 'Ireland'),
('Leila Nazari',     'DataSync Pro',   'The AI-powered anomaly detection caught a data quality issue we had missed for months. Genuinely impressive.', 5.0, '2026-06-09', 'Canada');

-- STEP 4: Verify your data loaded correctly
SELECT * FROM CUSTOMER_FEEDBACK ORDER BY SUBMITTED_DATE;

-- STEP 5: Verify the record count,average rating per product as per review and review count as per country
SELECT COUNT(*) AS total_reviews FROM CUSTOMER_FEEDBACK;

SELECT PRODUCT, 
       COUNT(*) AS review_count,
       ROUND(AVG(RATING), 2) AS avg_rating
FROM CUSTOMER_FEEDBACK
GROUP BY PRODUCT
ORDER BY avg_rating DESC;

SELECT COUNTRY, COUNT(*) AS reviews
FROM CUSTOMER_FEEDBACK
GROUP BY COUNTRY
ORDER BY reviews DESC;
