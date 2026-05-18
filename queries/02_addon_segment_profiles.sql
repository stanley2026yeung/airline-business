-- =========================================================
-- File: 02_addon_segment_profiles.sql
-- Author: Stanley Yeung
-- Dataset: customer_booking (https://www.kaggle.com/datasets/ememque/customer-booking/data, Rows: 50,000, Licence: Public)
--
-- BUSINESS QUESTION
-- Which customer segments buy the most add-ons, and what do they
-- have in common?
--
-- WHY THIS MATTERS
-- Ancillary revenue analysis
-- helps identify which customer groups are more likely to buy baggage,
-- preferred seats, and meals, so marketing and CRM teams can target
-- them more effectively.
-- =========================================================

SELECT
    sales_channel
  , trip_type
  , booking_origin

    -- Total booking records in this segment
  , COUNT(*) AS total_bookings

    -- Count only completed bookings
  , SUM(
        CASE
            WHEN booking_complete = 1 THEN 1
            ELSE 0
        END
    ) AS completed_bookings

    -- Add-on totals by type
  , SUM(extra_baggage) AS baggage_addons
  , SUM(preferred_seat) AS seat_addons
  , SUM(in_flight_meals) AS meal_addons

    -- Combined add-on count across all 3 ancillary products
  , SUM(
        extra_baggage
      + preferred_seat
      + in_flight_meals
    ) AS total_addons

    -- Average number of passengers in each segment
  , ROUND(AVG(num_passengers), 2) AS avg_passengers

    -- Average booking lead time
  , ROUND(AVG(purchase_lead), 2) AS avg_purchase_lead_days

    -- Completion rate for the segment
  , ROUND(
        SUM(
            CASE
                WHEN booking_complete = 1 THEN 1.0
                ELSE 0
            END
        ) / COUNT(*) * 100
      , 2
    ) AS completion_rate_pct

    -- Average addons per completed booking
  , ROUND(
        SUM(
            extra_baggage
          + preferred_seat
          + in_flight_meals
        ) * 1.0
        / NULLIF(
            SUM(
                CASE
                    WHEN booking_complete = 1 THEN 1
                    ELSE 0
                END
            ), 0
        )
      , 2
    ) AS avg_addons_per_completed_booking

FROM customer_booking

-- Optional filter: only keep segments with meaningful sample size
GROUP BY
    sales_channel
  , trip_type
  , booking_origin

HAVING COUNT(*) >= 20

-- Highest ancillary value segments first
ORDER BY total_addons DESC, completion_rate_pct DESC;

-- EXPECTED INTERPRETATION
-- - High-addon segments are strong targets for upsell bundles.
-- - If a segment has high add-on appetite but lower completion,
--   there may be revenue leakage during checkout.
-- - Useful for campaign targeting and ancillary offer design.