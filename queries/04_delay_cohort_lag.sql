-- =========================================================
-- File: 04_delay_cohort_lag.sql
-- Author: Stanley Yeung
-- Dataset: Airline-Passenger-Satisfaction.csv (https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction, Rows: 120,000, Licence: Public)
--
-- BUSINESS QUESTION
-- At what delay threshold does passenger satisfaction drop sharply?
--
-- WHY THIS MATTERS
-- This goes beyond average delay reporting. It helps define
-- operational thresholds where the customer experience starts
-- to deteriorate materially, supporting SLA and service recovery logic.
--
-- KEY SQL CONCEPTS
-- - Cohort banding with CASE WHEN
-- - LAG() window function
-- - Delta analysis between adjacent bands
-- =========================================================

WITH delay_banded AS (
    SELECT
        CASE
            WHEN "Departure_Delay_in_Minutes" = 0 THEN '01: No delay'
            WHEN "Departure_Delay_in_Minutes" BETWEEN 1 AND 15 THEN '02: 1_to_15'
            WHEN "Departure_Delay_in_Minutes" BETWEEN 16 AND 30 THEN '03: 16_to_30'
            WHEN "Departure_Delay_in_Minutes" BETWEEN 31 AND 60 THEN '04: 31_to_60'
            WHEN "Departure_Delay_in_Minutes" BETWEEN 61 AND 120 THEN '05: 61_to_120'
            WHEN "Departure_Delay_in_Minutes" BETWEEN 121 AND 240 THEN '06: 121_to_240'
            ELSE '06: 240_plus'
        END AS delay_band
      , satisfaction
    FROM AirlinePassengerSatisfaction
),
cohort_summary AS (
    SELECT
        delay_band
      , COUNT(*) AS total_passengers
      , ROUND(
            SUM(
                CASE
                    WHEN satisfaction = 'satisfied' THEN 1.0
                    ELSE 0
                END
            ) / COUNT(*) * 100
          , 2
        ) AS satisfaction_rate_pct
    FROM delay_banded
    GROUP BY delay_band
)
SELECT
    delay_band
  , total_passengers
  , satisfaction_rate_pct
  , LAG(satisfaction_rate_pct) OVER (ORDER BY delay_band) AS previous_band_satisfaction_rate
  , ROUND(
        satisfaction_rate_pct
        - LAG(satisfaction_rate_pct) OVER (ORDER BY delay_band)
      , 2
    ) AS change_vs_previous_band_pct
FROM cohort_summary
ORDER BY delay_band;

-- EXPECTED INTERPRETATION
-- - Large negative movement between bands signals a likely
--   pain threshold for passengers.
-- - That threshold can support disruption messaging and
--   operational escalation policies.