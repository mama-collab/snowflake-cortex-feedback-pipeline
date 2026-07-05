-- ============================================================
-- CUSTOMER FEEDBACK INTELLIGENCE PIPELINE
-- Session 2: AI Sentiment Analysis with Snowflake Cortex
-- Priya | @CompoundingMind | Built during Sunning's nap times
-- ============================================================

-- STEP 1: Add sentiment score column to existing table
ALTER TABLE CUSTOMER_FEEDBACK 
ADD COLUMN SENTIMENT_SCORE FLOAT;

-- STEP 2: Run CORTEX.SENTIMENT on every review
-- This is the magic moment — AI reads every review instantly
UPDATE CUSTOMER_FEEDBACK
SET SENTIMENT_SCORE = SNOWFLAKE.CORTEX.SENTIMENT(FEEDBACK_TEXT);

-- STEP 3: See the results — your first AI output!
SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    SENTIMENT_SCORE,
    FEEDBACK_TEXT
FROM CUSTOMER_FEEDBACK
ORDER BY SENTIMENT_SCORE ASC;

-- STEP 4: Label each review clearly
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
    FEEDBACK_TEXT
FROM CUSTOMER_FEEDBACK
ORDER BY SENTIMENT_SCORE ASC;

-- STEP 5: The money shot — sentiment by product
SELECT 
    PRODUCT,
    COUNT(*) AS total_reviews,
    ROUND(AVG(SENTIMENT_SCORE), 3) AS avg_sentiment,
    SUM(CASE WHEN SENTIMENT_SCORE >= 0.5 THEN 1 ELSE 0 END) AS positive_count,
    SUM(CASE WHEN SENTIMENT_SCORE <= -0.3 THEN 1 ELSE 0 END) AS negative_count,
    SUM(CASE WHEN SENTIMENT_SCORE > -0.3 AND SENTIMENT_SCORE < 0.5 THEN 1 ELSE 0 END) AS neutral_count
FROM CUSTOMER_FEEDBACK
GROUP BY PRODUCT
ORDER BY avg_sentiment DESC;

-- STEP 6: Most negative reviews — who needs urgent attention?
SELECT 
    CUSTOMER_NAME,
    PRODUCT,
    RATING,
    SENTIMENT_SCORE,
    FEEDBACK_TEXT
FROM CUSTOMER_FEEDBACK
WHERE SENTIMENT_SCORE <= -0.3
ORDER BY SENTIMENT_SCORE ASC;

-- ============================================================
-- END OF SESSION 2
-- Next session: CORTEX.SUMMARIZE + EXTRACT_ANSWER
-- ============================================================
