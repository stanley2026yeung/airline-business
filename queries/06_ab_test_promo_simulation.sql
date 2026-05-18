-- =========================================================
-- File: 06_ab_test_promo_simulation.sql
-- Author: Stanley Yeung
-- Dataset: customer_booking (https://www.kaggle.com/datasets/ememque/customer-booking/data, Rows: 50,000, Licence: Public)
--
-- BUSINESS QUESTION
-- Do early bookers (simulated promo group) convert better than
-- later bookers (control group)?
--
-- WHY THIS MATTERS
-- Customers who book earlier have higher completion rates and may
-- represent a stronger target for early-bird promotional campaigns.
-- =========================================================

WITH ab_groups AS (
    SELECT
        sales_channel
      , trip_type
      , booking_origin
      , purchase_lead
      , booking_complete
      , wants_extra_baggage
      , wants_preferred_seat
      , wants_in_flight_meals
      , CASE
            WHEN purchase_lead >= 30 THEN 'A: Early_Booker_Promo_Group'
            ELSE 'B: Last_Minute_Control_Group'
        END AS test_group
    FROM customer_booking
),
group_summary AS (
    SELECT
        test_group
      , COUNT(*) AS total_sessions
      , SUM(CASE WHEN booking_complete = 1 THEN 1 ELSE 0 END) AS conversions
      , ROUND(
            SUM(CASE WHEN booking_complete = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100
          , 2
        ) AS conversion_rate_pct
      , ROUND(AVG(purchase_lead), 2) AS avg_purchase_lead
      , ROUND(
            AVG(
                wants_extra_baggage
              + wants_preferred_seat
              + wants_in_flight_meals
            )
          , 2
        ) AS avg_addons_selected
    FROM ab_groups
    GROUP BY test_group
),
lift_output AS (
    SELECT
        g.*
      , MAX(
            CASE
                WHEN test_group = 'B: Last_Minute_Control_Group'
                THEN conversion_rate_pct
            END
        ) OVER () AS control_conversion_rate_pct
    FROM group_summary g
)
SELECT
    test_group
  , total_sessions
  , conversions
  , conversion_rate_pct
  , avg_purchase_lead
  , avg_addons_selected
  , control_conversion_rate_pct
  , ROUND(
        conversion_rate_pct - control_conversion_rate_pct
      , 2
    ) AS absolute_lift_pct
  , ROUND(
        (conversion_rate_pct - control_conversion_rate_pct)
        / NULLIF(control_conversion_rate_pct, 0) * 100
      , 2
    ) AS relative_lift_pct
FROM lift_output
ORDER BY test_group;

-- EXPECTED INTERPRETATION
-- - If the promo group materially outperforms control, early-bird
--   campaigns may be worth further testing.
-- - In an interview, clearly state this is simulated observational
--   analysis, not a true randomised experiment.