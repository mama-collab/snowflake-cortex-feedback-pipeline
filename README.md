# snowflake-cortex-feedback-pipeline
AI-powered customer feedback intelligence pipeline built with Snowflake Cortex — sentiment analysis, summarization, automated pipeline, Streamlit dashboard
# ❄️ Customer Feedback Intelligence Pipeline
### Built with Snowflake Cortex AI · Pure SQL · No Python Required

![Snowflake](https://img.shields.io/badge/Snowflake-Cortex-29B5E8?logo=snowflake)
![Python](https://img.shields.io/badge/Python-Streamlit-3776AB?logo=python)
![SQL](https://img.shields.io/badge/SQL-Pure%20SQL-orange)
![Status](https://img.shields.io/badge/Status-Live-brightgreen)

> *Built during my daughter Sunning's nap times — 6 sessions, 
> 30 minutes each. Priya | @Compounding Mind

---

## 🎯 The Problem

Enterprise teams have thousands of customer touchpoints — 
reviews, support tickets, survey responses — with no scalable 
way to understand them.

Traditional approaches require:
- ❌ A Python developer
- ❌ A separate ML platform  
- ❌ Weeks of integration work
- ❌ Multiple tool licenses

**This pipeline replaces all of that with pure SQL inside 
Snowflake.**

---

## ✅ The Solution

A fully automated AI pipeline built entirely inside Snowflake 
CoCo — sentiment analysis, summarization, targeted Q&A, 
automated processing, and a live dashboard.

**One platform. Pure SQL. Zero external tools.**

---

## 🏗 Pipeline Architecture

Raw Customer Feedback

↓

Session 1: Database Setup + Data Loading

↓

Session 2: CORTEX.SENTIMENT (-1.0 to +1.0 per review)

↓

Session 3: CORTEX.SUMMARIZE + CORTEX.EXTRACT_ANSWER

↓

Session 4: Automated Pipeline (Snowflake Tasks + Streams)

↓

Session 5: Live Streamlit Dashboard

↓

Actionable AI Insights — Fully Automated

---

## 🧠 Snowflake Cortex Functions Used

| Function | What it does | Example output |
|---|---|---|
| `CORTEX.SENTIMENT` | Scores emotion -1.0 to +1.0 | `-0.79` = very negative |
| `CORTEX.SUMMARIZE` | One-line AI summary | `"Crashed during migration"` |
| `CORTEX.EXTRACT_ANSWER` | Q&A against raw text | `"bugs"`, `"support"` |

---

## 📁 Repository Structure

snowflake-cortex-feedback-pipeline/

│

├── sql/

│   ├── 01_setup_database.sql      # Database, schema, sample data

│   ├── 02_sentiment_analysis.sql  # CORTEX.SENTIMENT pipeline

│   ├── 03_summarize_extract.sql   # CORTEX.SUMMARIZE + EXTRACT_ANSWER

│   ├── 04_pipeline_automation.sql # Tasks + Streams automation

│   └── 05_dashboard_view.sql      # Streamlit-ready view

│

├── streamlit/

│   └── streamlit_app.py           # Interactive dashboard

│

└── README.md
---

## 🚀 How to Run

### Prerequisites
- Snowflake account (free CoCo tier works perfectly)
- AWS US East region recommended for full Cortex support

### Step by Step

**1. Run SQL files in order:**
```sql
-- In Snowflake SQL editor, run each file in sequence:
-- 01 → 02 → 03 → 04 → 05
```

**2. Create Streamlit app:**
- In Snowflake CoCo → Apps → Streamlit → New
- Paste contents of `streamlit/streamlit_app.py`
- Hit Run

**3. View your live dashboard!**

---

## 📊 Sample Output

### Sentiment by Product
| Product | Avg Sentiment | Positive | Negative |
|---|---|---|---|
| DataSync Pro | 0.516 | 6 | 0 |
| CloudETL Pro | 0.362 | 2 | 0 |
| CloudETL Basic | -0.220 | 1 | 3 |

### AI-Extracted Insights (CloudETL Basic)
| Complaint | Praise | Sentiment |
|---|---|---|
| crashed | support | -0.79 |
| bugs | bugs | -0.75 |
| unreliable | scheduler | -0.64 |

---

## 🛠 Tech Stack

- **Platform:** Snowflake CoCo (free tier)
- **AI/ML:** Snowflake Cortex (SENTIMENT, SUMMARIZE, EXTRACT_ANSWER)
- **Automation:** Snowflake Tasks + Streams
- **Dashboard:** Streamlit in Snowflake
- **Language:** SQL + Python
- **Cloud:** AWS US East

---

## 📺 Watch the Full Tutorial

🎥 **YouTube:** https://youtube.com/@compoundingmind

Follow along session by session on 
coming soon
---

## 💼 Work With Me

This is the kind of pipeline I build for enterprise clients 
in financial services, pharma, and retail.

- 📅 [Book a free 15-min call](https://calendly.com/mama-priyadarsini/15-minute-business-strategy-call)
- 🔗 [LinkedIn](https://linkedin.com/in/mpriyadarsini)
- 🎥 [YouTube — Compounding Mind](https://youtube.com/@compoundingmind)

---

## 👩‍💻 About

Built by **M Priyadarsini** — Senior Data Engineer & Architect 
with 20 years of enterprise experience across financial 
services, pharma, and retail.

Clients include: Sun Life Financial · CPPIB · Sanofi · 
Nielsen · Fairstone Bank

Available for remote consulting — Canada + US time zones.
📅 [Book a free 15-min call](https://calendly.com/mama-priyadarsini/15-minute-business-strategy-call)

*Built during Sunning's nap times. One step a day.* 🍼❄️
