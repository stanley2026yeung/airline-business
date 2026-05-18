-- =========================================================
-- File: 01_channel_completion_rate.sql
-- Author: Stanley Yeung
-- Dataset: customer_booking (https://www.kaggle.com/datasets/ememque/customer-booking/data, Rows: 50,000, Licence: Public)
--
-- BUSINESS QUESTION
-- Which booking channel has the highest booking completion rate?
--
-- WHY THIS MATTERS
-- This is a core digital funnel question. It helps identify whether
-- one acquisition / booking channel is performing better than another,
-- and whether optimisation effort should focus on Mobile or Internet.
-- =========================================================

SELECT
    sales_channel AS booking_channel
    -- Count all booking attempts / sessions in each channel
  , COUNT(*) AS total_sessions

    -- Count only completed bookings
  , SUM(
        CASE
            WHEN booking_complete = 1 THEN 1
            ELSE 0
        END
    ) AS completed_bookings

    -- Count incomplete / dropped bookings
  , SUM(
        CASE
            WHEN booking_complete = 0 THEN 1
            ELSE 0
        END
    ) AS incomplete_bookings

    -- Calculate completion rate as percentage
  , ROUND(
        SUM(
            CASE
                WHEN booking_complete = 1 THEN 1.0
                ELSE 0
            END
        ) / COUNT(*) * 100
      , 2
    ) AS completion_rate_pct

    -- Calculate drop-off rate as percentage
  , ROUND(
        SUM(
            CASE
                WHEN booking_complete = 0 THEN 1.0
                ELSE 0
            END
        ) / COUNT(*) * 100
      , 2
    ) AS dropoff_rate_pct

FROM customer_booking

-- Group the analysis by booking channel
GROUP BY sales_channel

-- Show best-performing channel first
ORDER BY completion_rate_pct DESC;

-- EXPECTED INTERPRETATION
-- - The channel with the higher completion rate is converting better.
-- - The channel with the higher drop-off rate likely has friction in the journey.
-- - This can support app/web UX prioritisation and campaign landing strategy.