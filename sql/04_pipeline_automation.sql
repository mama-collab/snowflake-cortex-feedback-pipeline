-- ============================================================
-- CUSTOMER FEEDBACK INTELLIGENCE PIPELINE
-- Session 4: Automated Pipeline — Tasks + Streams
-- Priya | @CompoundingMind | Built during Sunning's nap times
-- ============================================================

-- STEP 1: Create a stream to detect new incoming feedback
-- Stream watches the table and captures any new rows added
CREATE OR REPLACE STREAM FEEDBACK_STREAM
ON TABLE CUSTOMER_FEEDBACK
SHOW_INITIAL_ROWS = FALSE;

-- Verify stream created
SHOW STREAMS;

-- STEP 2: Create a staging table for new incoming feedback
-- This simulates new reviews arriving from a CRM or support tool
CREATE OR REPLACE TABLE CUSTOMER_FEEDBACK_STAGING (
    CUSTOMER_NAME   VARCHAR(100),
    PRODUCT         VARCHAR(100),
    FEEDBACK_TEXT   VARCHAR(2000),
    RATING          NUMBER(2,1),
    SUBMITTED_DATE  DATE,
    COUNTRY         VARCHAR(50)
);

-- STEP 3: Create the enrichment procedure
-- This runs all 3 Cortex functions automatically on new rows
CREATE OR REPLACE PROCEDURE ENRICH_NEW_FEEDBACK()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Insert new rows from staging into main table
    INSERT INTO CUSTOMER_FEEDBACK 
        (CUSTOMER_NAME, PRODUCT, FEEDBACK_TEXT, RATING, SUBMITTED_DATE, COUNTRY)
    SELECT 
        CUSTOMER_NAME, PRODUCT, FEEDBACK_TEXT, RATING, SUBMITTED_DATE, COUNTRY
    FROM CUSTOMER_FEEDBACK_STAGING;

    -- Run all 3 Cortex functions on unenriched rows
    UPDATE CUSTOMER_FEEDBACK
    SET 
        SENTIMENT_SCORE = SNOWFLAKE.CORTEX.SENTIMENT(FEEDBACK_TEXT),
        AI_SUMMARY = SNOWFLAKE.CORTEX.SUMMARIZE(FEEDBACK_TEXT),
        MAIN_COMPLAINT = SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
            FEEDBACK_TEXT,
            'What is the main complaint or problem mentioned?'
        )[0]['answer']::STRING,
        MAIN_PRAISE = SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
            FEEDBACK_TEXT,
            'What does the customer like or praise?'
        )[0]['answer']::STRING
    WHERE SENTIMENT_SCORE IS NULL;

    -- Clear staging table after processing
    TRUNCATE TABLE CUSTOMER_FEEDBACK_STAGING;

    RETURN 'Enrichment complete — ' || CURRENT_TIMESTAMP();
END;
$$;

-- STEP 4: Create the automated Task
-- Runs every 5 minutes automatically — no human needed!
CREATE OR REPLACE TASK FEEDBACK_ENRICHMENT_TASK
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '5 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('FEEDBACK_STREAM')
AS
    CALL ENRICH_NEW_FEEDBACK();

-- STEP 5: Activate the task
-- Tasks start suspended by default — resume to activate
ALTER TASK FEEDBACK_ENRICHMENT_TASK RESUME;

-- Verify task is running
SHOW TASKS;

-- STEP 6: Test it! Insert new feedback into staging
-- Watch the pipeline process it automatically
INSERT INTO CUSTOMER_FEEDBACK_STAGING VALUES
('Priya Sunning', 'DataSync Pro', 
 'This AI pipeline is incredible. Built it during nap times and it works flawlessly. Game changer for our team.', 
 5.0, '2026-06-30', 'Canada'),
('Test Customer', 'CloudETL Basic', 
 'Terrible experience. System crashed during critical migration. Lost two days of work. Completely unacceptable.', 
 1.0, '2026-06-30', 'USA');

-- STEP 7: Manually trigger procedure to test immediately
CALL ENRICH_NEW_FEEDBACK();

-- STEP 8: Verify new rows are enriched automatically 
SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    SENTIMENT_SCORE,
    AI_SUMMARY,
    MAIN_COMPLAINT,
    MAIN_PRAISE
FROM CUSTOMER_FEEDBACK
WHERE SUBMITTED_DATE = '2026-06-30'
ORDER BY SENTIMENT_SCORE ASC;

-- STEP 9: The money shot — full enriched pipeline view
SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    SENTIMENT_SCORE,
    CASE 
        WHEN SENTIMENT_SCORE >= 0.5  THEN '😊 Positive'
        WHEN SENTIMENT_SCORE <= -0.3 THEN '😠 Negative'
        ELSE '😐 Neutral'
    END AS SENTIMENT_LABEL,
    AI_SUMMARY,
    MAIN_COMPLAINT,
    MAIN_PRAISE
FROM CUSTOMER_FEEDBACK
ORDER BY SUBMITTED_DATE DESC
LIMIT 5;

-- ============================================================
-- END OF SESSION 4
-- Next session: Streamlit Dashboard inside Snowflake
-- ============================================================
