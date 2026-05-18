# Airline Business Insights — SQL Portfolio

**Stanley Yeung**  · Hong Kong

---

## Overview

This demonstrates SQL-based business insights analysis applied to the airline industry. It is designed to showcase — digital booking funnel, customer segmentation, customer experience, and revenue opportunity identification.

---

## Business Context

The analysis is structured around the kind of questions:

- Which digital channels convert bookings most effectively?
- Which customer segments generate the most ancillary revenue?
- Where does the passenger experience break down?
- At what delay threshold does satisfaction collapse?
- Which Economy passengers are most likely to respond to an upgrade offer?
- What does a well-structured A/B test readout look like?
- Where is revenue leaking — and which segments are the priority?
- What does a single-page executive KPI summary look like?

---

## Datasets

Two public datasets are used across all queries. See [`data_sources/airline_data_sources.md`](data_sources/airline_data_sources.md) for full details, column references, and download links.

| Table name used in SQL | Source file | Rows | Description |
|---|---|---|---|
| `customer_booking` | `customer_booking.csv` | 50,000 , https://www.kaggle.com/datasets/ememque/customer-booking/data | Airline booking sessions — channel, origin, trip type, add-ons, completion status |
| `satisfaction` | `Airline-Passenger-Satisfaction.csv` | 103,904 , https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction | Passenger satisfaction survey — class, travel type, service scores, delays |

---

## Query Index

Eight queries are organised into four commercial chapters. Each file is self-contained with inline comments explaining the business question, SQL concepts used, and how to interpret the results.

### Chapter 1 — Digital Booking Funnel

| File | Business Question | Key SQL |
|---|---|---|
| [`01_channel_completion_rate.sql`](queries/01_channel_completion_rate.sql) | Which booking channel — Internet or Mobile — has the highest completion rate?
| [`02_addon_segment_profiles.sql`](queries/02_addon_segment_profiles.sql) | Which customer segments buy the most add-ons, and what do they have in common?

### Chapter 2 — Customer Segmentation & Value

| File | Business Question | Key SQL |
|---|---|---|
| [`03_service_touchpoint_gap.sql`](queries/03_service_touchpoint_gap.sql) | Which service touchpoints show the biggest gap between satisfied and dissatisfied passengers? 
| [`04_delay_cohort_lag.sql`](queries/04_delay_cohort_lag.sql) | At what delay threshold does passenger satisfaction drop most sharply? 

### Chapter 3 — Customer Experience Analytics

| File | Business Question | Key SQL |
|---|---|---|
| [`05_upsell_probability_score.sql`](queries/05_upsell_probability_score.sql) | Which Economy loyal passengers are most likely to respond to an upgrade offer? 
| [`06_ab_test_promo_simulation.sql`](queries/06_ab_test_promo_simulation.sql) | Do early bookers (simulated promo group) convert better than last-minute bookers? 
### Chapter 4 — Revenue Opportunity

| File | Business Question | Key SQL |
|---|---|---|
| [`07_revenue_leakage_detection.sql`](queries/07_revenue_leakage_detection.sql) | Which booking segments show the biggest revenue leakage risk? 
| [`08_executive_kpi_report.sql`](queries/08_executive_kpi_report.sql) | What does a single-page executive KPI summary look like across both datasets? 

---


## Project Structure

```
airline-business/
├── README.md                               ← This file
├── data_sources/                           ← Dataset details and download links
│   └── Airline-Passenger-Satisfaction.csv  
│   └── customer_booking.csv       
├── queries/
│   ├── 01_channel_completion_rate.sql
│   ├── 02_addon_segment_profiles.sql
│   ├── 03_service_touchpoint_gap.sql
│   ├── 04_delay_cohort_lag.sql
│   ├── 05_upsell_probability_score.sql
│   ├── 06_ab_test_promo_simulation.sql
│   ├── 07_revenue_leakage_detection.sql
│   └── 08_executive_kpi_report.sql
└── outputs/
      └── CSV/
          ├── 01_channel_completion_rate.csv
          ├── 02_addon_segment_profiles.csv
          ├── 03_service_touchpoint_gap.csv
          ├── 04_delay_cohort_lag.csv
          ├── 05_upsell_probability_score.csv
          ├── 06_ab_test_promo_simulation.csv
          ├── 07_revenue_leakage_detection.csv
          └── 08_executive_kpi_report.csv
      └── screencap/
          ├── 01_channel_completion_rate.png
          ├── 02_addon_segment_profiles.png
          ├── 03_service_touchpoint_gap.png
          ├── 04_delay_cohort_lag.png
          ├── 05_upsell_probability_score.png
          ├── 06_ab_test_promo_simulation.png
          ├── 07_revenue_leakage_detection.png
          └── 08_executive_kpi_report.png
```


## About


This SQL portfolio was built to demonstrate applied business analytics skills in an airline commercial context.

---

*Last updated: May 2026*
