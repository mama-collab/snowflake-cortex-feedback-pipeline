-- ============================================================
-- CUSTOMER FEEDBACK INTELLIGENCE PIPELINE
-- Session 3: AI Summarization + Targeted Q&A with Cortex
-- Priya | @CompoundingMind | Built during Sunning's nap times
-- ============================================================

-- STEP 1: Add summary and key-complaint columns
ALTER TABLE CUSTOMER_FEEDBACK 
ADD COLUMN AI_SUMMARY VARCHAR(500);

ALTER TABLE CUSTOMER_FEEDBACK 
ADD COLUMN MAIN_COMPLAINT VARCHAR(500);

ALTER TABLE CUSTOMER_FEEDBACK 
ADD COLUMN MAIN_PRAISE VARCHAR(500);

-- STEP 2: Run CORTEX.SUMMARIZE on every review
-- AI condenses each review into one clean sentence
UPDATE CUSTOMER_FEEDBACK
SET AI_SUMMARY = SNOWFLAKE.CORTEX.SUMMARIZE(FEEDBACK_TEXT);

-- STEP 3: Run EXTRACT_ANSWER — ask AI a specific question per row
-- This is the "magic" moment — targeted Q&A against raw text

UPDATE CUSTOMER_FEEDBACK
SET MAIN_COMPLAINT = SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
    FEEDBACK_TEXT,
    'What is the main complaint or problem mentioned?'
)[0]['answer']::STRING;

UPDATE CUSTOMER_FEEDBACK
SET MAIN_PRAISE = SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
    FEEDBACK_TEXT,
    'What does the customer like or praise?'
)[0]['answer']::STRING;


-- STEP 4: See everything together
SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    SENTIMENT_SCORE,
    AI_SUMMARY,
    FEEDBACK_TEXT
FROM CUSTOMER_FEEDBACK
ORDER BY SENTIMENT_SCORE ASC;

SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    SENTIMENT_SCORE,
    AI_SUMMARY,
    FEEDBACK_TEXT,
    MAIN_PRAISE,
    MAIN_COMPLAINT
FROM CUSTOMER_FEEDBACK
ORDER BY SENTIMENT_SCORE ASC;
-- Check again
SELECT CUSTOMER_NAME, FEEDBACK_TEXT,AI_SUMMARY,MAIN_COMPLAINT,MAIN_PRAISE
FROM CUSTOMER_FEEDBACK 
LIMIT 5;

-- STEP 5: The complaint extraction view 
SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    MAIN_COMPLAINT
FROM CUSTOMER_FEEDBACK
WHERE SENTIMENT_SCORE <= -0.3
ORDER BY SENTIMENT_SCORE ASC;

-- STEP 6: Most common complaint themes across negative reviews

SELECT 
    PRODUCT,
    FEEDBACK_TEXT,
    MAIN_COMPLAINT,
    MAIN_PRAISE,
    SENTIMENT_SCORE
FROM CUSTOMER_FEEDBACK
WHERE PRODUCT = 'CloudETL Basic'
ORDER BY SENTIMENT_SCORE ASC;

-- ============================================================
-- END OF SESSION 3
-- Next session: Automated pipeline with Snowflake Tasks + Streams
-- ============================================================
