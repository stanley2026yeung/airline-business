-- =========================================================
-- File: 08_executive_kpi_report.sql
-- Author: Stanley Yeung
-- Dataset: customer_booking (https://www.kaggle.com/datasets/ememque/customer-booking/data, Rows: 50,000, Licence: Public) +
-- Dataset: Airline-Passenger-Satisfaction.csv (https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction, Rows: 120,000, Licence: Public)
--
-- BUSINESS QUESTION
-- Can we create a simple executive KPI summary from both datasets
-- in one query output?
--
-- WHY THIS MATTERS
-- A concise KPI pack rather than multiple separate tables. 
-- This query simulates a one-page summary
-- view that can feed dashboards or management readouts.
-- =========================================================

SELECT
    'Booking' AS kpi_group
  , 'Total booking sessions' AS kpi_name
  , CAST(COUNT(*) AS TEXT) AS kpi_value
FROM customer_booking

UNION ALL

SELECT
    'Booking'
  , 'Overall booking completion rate'
  , CAST(
        ROUND(
            SUM(CASE WHEN booking_complete = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100
          , 2
        ) AS TEXT
    ) || '%'
FROM customer_booking

UNION ALL

SELECT
    'Booking'
  , 'Internet channel completion rate'
  , CAST(
        ROUND(
            SUM(
                CASE
                    WHEN sales_channel = 'Internet' AND booking_complete = 1 THEN 1.0
                    ELSE 0
                END
            )
            / NULLIF(
                SUM(
                    CASE
                        WHEN sales_channel = 'Internet' THEN 1.0
                        ELSE 0
                    END
                ), 0
            ) * 100
          , 2
        ) AS TEXT
    ) || '%'
FROM customer_booking

UNION ALL

SELECT
    'Booking'
  , 'Mobile channel completion rate'
  , CAST(
        ROUND(
            SUM(
                CASE
                    WHEN sales_channel = 'Mobile' AND booking_complete = 1 THEN 1.0
                    ELSE 0
                END
            )
            / NULLIF(
                SUM(
                    CASE
                        WHEN sales_channel = 'Mobile' THEN 1.0
                        ELSE 0
                    END
                ), 0
            ) * 100
          , 2
        ) AS TEXT
    ) || '%'
FROM customer_booking

UNION ALL

SELECT
    'Ancillary'
  , 'Completed bookings with at least 1 add-on'
  , CAST(
        ROUND(
            SUM(
                CASE
                    WHEN booking_complete = 1
                     AND (wants_extra_baggage + wants_preferred_seat + wants_in_flight_meals) > 0
                    THEN 1.0
                    ELSE 0
                END
            )
            / NULLIF(
                SUM(
                    CASE
                        WHEN booking_complete = 1 THEN 1.0
                        ELSE 0
                    END
                ), 0
            ) * 100
          , 2
        ) AS TEXT
    ) || '%'
FROM customer_booking

UNION ALL

SELECT
    'Customer Experience'
  , 'Overall passenger satisfaction rate'
  , CAST(
        ROUND(
            SUM(CASE WHEN satisfaction = 'satisfied' THEN 1.0 ELSE 0 END) / COUNT(*) * 100
          , 2
        ) AS TEXT
    ) || '%'
FROM AirlinePassengerSatisfaction

UNION ALL

SELECT
    'Customer Experience'
  , 'Business class satisfaction rate'
  , CAST(
        ROUND(
            SUM(
                CASE
                    WHEN "Class" = 'Business' AND satisfaction = 'satisfied' THEN 1.0
                    ELSE 0
                END
            )
            / NULLIF(
                SUM(
                    CASE
                        WHEN "Class" = 'Business' THEN 1.0
                        ELSE 0
                    END
                ), 0
            ) * 100
          , 2
        ) AS TEXT
    ) || '%'
FROM AirlinePassengerSatisfaction

UNION ALL

SELECT
    'Operations'
  , 'Average departure delay (minutes)'
  , CAST(ROUND(AVG("Departure_Delay_in_Minutes"), 2) AS TEXT)
FROM AirlinePassengerSatisfaction

UNION ALL

SELECT
    'Operations'
  , 'Average arrival delay (minutes)'
  , CAST(ROUND(AVG("Arrival_Delay_in_Minutes"), 2) AS TEXT)
FROM AirlinePassengerSatisfaction;

-- EXPECTED INTERPRETATION
-- - This output works like a simple executive KPI scorecard.
-- - It can be exported directly into a dashboard, slide, or insight pack.