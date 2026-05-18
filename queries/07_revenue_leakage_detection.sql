-- =========================================================
-- File: 07_revenue_leakage_detection.sql
-- Author: Stanley Yeung
-- Dataset: customer_booking (https://www.kaggle.com/datasets/ememque/customer-booking/data, Rows: 50,000, Licence: Public)
--
-- BUSINESS QUESTION
-- Which booking segments show the biggest revenue leakage risk?
--
-- WHY THIS MATTERS
-- Revenue leakage opportunities. This query highlights where the highest
-- volume of incomplete bookings occurs, helping prioritise action.
-- =========================================================

WITH segment_performance AS (
    SELECT
        sales_channel
      , trip_type
      , booking_origin
      , COUNT(*) AS total_sessions
      , SUM(CASE WHEN booking_complete = 1 THEN 1 ELSE 0 END) AS completed_sessions
      , SUM(CASE WHEN booking_complete = 0 THEN 1 ELSE 0 END) AS dropped_sessions

      -- Completion and drop rates
      , ROUND(
            SUM(CASE WHEN booking_complete = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100
          , 2
        ) AS completion_rate_pct
      , ROUND(
            SUM(CASE WHEN booking_complete = 0 THEN 1.0 ELSE 0 END) / COUNT(*) * 100
          , 2
        ) AS drop_rate_pct

      -- Crude ancillary opportunity index from dropped sessions
      , SUM(
            CASE
                WHEN booking_complete = 0
                THEN wants_extra_baggage + wants_preferred_seat + wants_in_flight_meals
                ELSE 0
            END
        ) AS lost_addon_opportunities
    FROM customer_booking
    GROUP BY
        sales_channel
      , trip_type
      , booking_origin
    HAVING COUNT(*) >= 20
),
ranked_leakage AS (
    SELECT
        *
      , RANK() OVER (ORDER BY dropped_sessions DESC) AS volume_leakage_rank
      , RANK() OVER (ORDER BY drop_rate_pct DESC) AS rate_leakage_rank

      -- Simple composite priority score
      , ROUND(
            (dropped_sessions * 0.6) + (drop_rate_pct * 0.4)
          , 2
        ) AS leakage_priority_score
    FROM segment_performance
)
SELECT
    sales_channel
  , trip_type
  , booking_origin
  , total_sessions
  , completed_sessions
  , dropped_sessions
  , completion_rate_pct
  , drop_rate_pct
  , lost_addon_opportunities
  , volume_leakage_rank
  , rate_leakage_rank
  , leakage_priority_score
FROM ranked_leakage
ORDER BY leakage_priority_score DESC
LIMIT 20;

-- EXPECTED INTERPRETATION
-- - Top-ranked rows are the highest-priority leakage segments.
-- - These segments can be targeted for checkout fixes, CRM
--   reminders, or automated recovery messaging.