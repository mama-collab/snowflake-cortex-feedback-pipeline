-- ============================================================
-- CUSTOMER FEEDBACK INTELLIGENCE PIPELINE
-- Session 5: Streamlit Dashboard inside Snowflake
-- Priya | Compounding Mind | Built during Sunning's nap times
-- ============================================================

-- STEP 1: First run this SQL to create the view 
-- Dashboard will query this view
CREATE OR REPLACE VIEW FEEDBACK_DASHBOARD_VIEW AS
SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    SENTIMENT_SCORE,
    CASE 
        WHEN SENTIMENT_SCORE >= 0.5  THEN 'Positive'
        WHEN SENTIMENT_SCORE <= -0.3 THEN 'Negative'
        ELSE 'Neutral'
    END AS SENTIMENT_LABEL,
    AI_SUMMARY,
    MAIN_COMPLAINT,
    MAIN_PRAISE,
    SUBMITTED_DATE,
    COUNTRY,
    FEEDBACK_TEXT
FROM CUSTOMER_FEEDBACK
WHERE SENTIMENT_SCORE IS NOT NULL;

-- Verify view
SELECT * FROM FEEDBACK_DASHBOARD_VIEW;
--Create and deploy streamlit app,once it is verified,suspend the task to save the cost/credit
-- Suspend the task (stops it running every 5 mins)
ALTER TASK FEEDBACK_ENRICHMENT_TASK SUSPEND;

-- Verify it's suspended
SHOW TASKS;
-- Resume when needed
ALTER TASK FEEDBACK_ENRICHMENT_TASK RESUME;
-- ============================================================
-- End of Session 5
-- ============================================================
