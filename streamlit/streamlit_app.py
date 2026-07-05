# ============================================================
# CUSTOMER FEEDBACK INTELLIGENCE DASHBOARD
# Priya | @CompoundingMind | Built during Sunning's nap times
# ============================================================

import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

# Page config
st.set_page_config(
    page_title="Customer Feedback Intelligence",
    page_icon="❄️",
    layout="wide"
)
# Force reload after view update
st.cache_data.clear()
# Get Snowflake session
session = get_active_session()

# ── Header ──────────────────────────────────────────────────
st.title("❄️ Customer Feedback Intelligence Pipeline")
st.markdown("*Built with Snowflake Cortex AI · By Priya @ Compounding Mind*")
st.divider()

# ── Load data ───────────────────────────────────────────────
@st.cache_data
def load_data():
    return session.sql("""
        SELECT * FROM FEEDBACK_INTELLIGENCE.RAW.FEEDBACK_DASHBOARD_VIEW
    """).to_pandas()

df = load_data()

# ── Sidebar filters ─────────────────────────────────────────
st.sidebar.title("🔍 Filters")
products = ["All"] + sorted(df["PRODUCT"].unique().tolist())
selected_product = st.sidebar.selectbox("Product", products)

sentiments = ["All", "Positive", "Neutral", "Negative"]
selected_sentiment = st.sidebar.selectbox("Sentiment", sentiments)

# Apply filters
filtered_df = df.copy()
if selected_product != "All":
    filtered_df = filtered_df[filtered_df["PRODUCT"] == selected_product]
if selected_sentiment != "All":
    filtered_df = filtered_df[filtered_df["SENTIMENT_LABEL"] == selected_sentiment]

# ── KPI metrics row ─────────────────────────────────────────
st.subheader("📊 Overview")
col1, col2, col3, col4 = st.columns(4)

with col1:
    st.metric("Total Reviews", len(filtered_df))
with col2:
    avg_sentiment = filtered_df["SENTIMENT_SCORE"].mean()
    st.metric("Avg Sentiment", f"{avg_sentiment:.3f}")
with col3:
    positive_pct = (
        len(filtered_df[filtered_df["SENTIMENT_LABEL"] == "Positive"]) 
        / len(filtered_df) * 100
    ) if len(filtered_df) > 0 else 0
    st.metric("Positive Reviews", f"{positive_pct:.0f}%")
with col4:
    avg_rating = filtered_df["RATING"].mean()
    st.metric("Avg Rating", f"{avg_rating:.1f} ⭐")

st.divider()

# ── Sentiment by product chart ───────────────────────────────
st.subheader("🧠 AI Sentiment by Product")
col1, col2 = st.columns(2)

with col1:
    sentiment_by_product = filtered_df.groupby("PRODUCT")["SENTIMENT_SCORE"].mean().reset_index()
    sentiment_by_product.columns = ["Product", "Avg Sentiment"]
    st.bar_chart(sentiment_by_product.set_index("Product"))

with col2:
    sentiment_counts = filtered_df["SENTIMENT_LABEL"].value_counts().reset_index()
    sentiment_counts.columns = ["Sentiment", "Count"]
    st.bar_chart(sentiment_counts.set_index("Sentiment"))

st.divider()

# ── Sentiment label breakdown ────────────────────────────────
st.subheader("😊 Sentiment Distribution")
col1, col2, col3 = st.columns(3)

positive_df = filtered_df[filtered_df["SENTIMENT_LABEL"] == "Positive"]
neutral_df = filtered_df[filtered_df["SENTIMENT_LABEL"] == "Neutral"]
negative_df = filtered_df[filtered_df["SENTIMENT_LABEL"] == "Negative"]

with col1:
    st.success(f"😊 Positive: {len(positive_df)} reviews")
with col2:
    st.warning(f"😐 Neutral: {len(neutral_df)} reviews")
with col3:
    st.error(f"😠 Negative: {len(negative_df)} reviews")

st.divider()

# ── AI Insights table ────────────────────────────────────────
st.subheader("🔍 AI-Extracted Insights")
st.dataframe(
    filtered_df[[
        "CUSTOMER_NAME", "PRODUCT", "RATING",
        "SENTIMENT_SCORE", "SENTIMENT_LABEL",
        "AI_SUMMARY", "MAIN_COMPLAINT", "MAIN_PRAISE"
    ]].sort_values("SENTIMENT_SCORE"),
    use_container_width=True,
    hide_index=True
)

st.divider()

# ── Negative reviews alert ───────────────────────────────────
st.subheader("🚨 Negative Reviews — Needs Attention")
negative_reviews = filtered_df[
    filtered_df["SENTIMENT_LABEL"] == "Negative"
].sort_values("SENTIMENT_SCORE")

if len(negative_reviews) > 0:
    for _, row in negative_reviews.iterrows():
        with st.expander(
            f"😠 {row['CUSTOMER_NAME']} — {row['PRODUCT']} "
            f"(Score: {row['SENTIMENT_SCORE']:.2f})"
        ):
            st.write(f"**Feedback:** {row['FEEDBACK_TEXT']}")
            st.write(f"**AI Summary:** {row['AI_SUMMARY']}")
            st.write(f"**Main Complaint:** {row['MAIN_COMPLAINT']}")
            st.write(f"**Rating:** {row['RATING']} ⭐")
else:
    st.success("No negative reviews for selected filters!")

st.divider()

# ── Footer ───────────────────────────────────────────────────
st.markdown("""
*Built with ❄️ Snowflake Cortex AI during Sunning's nap times*  
*Compounding Mind — youtube.com/@compoundingmind*
""")
