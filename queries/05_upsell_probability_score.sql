-- =========================================================
-- File: 05_upsell_probability_score.sql
-- Author: Stanley Yeung
-- Dataset: Airline-Passenger-Satisfaction.csv (https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction, Rows: 120,000, Licence: Public)
--
-- BUSINESS QUESTION
-- Which Economy loyal passengers look most like strong upgrade /
-- upsell targets based on service preferences?
--
-- WHY THIS MATTERS
-- This simulates a commercial scoring model for identifying
-- passengers who may respond well to premium upsell messaging.
-- =========================================================

WITH business_benchmark AS (
    SELECT
        AVG("Seat_comfort") AS avg_business_seat_comfort
      , AVG("Inflight_entertainment") AS avg_business_entertainment
      , AVG("On_board_service") AS avg_business_onboard_service
      , AVG("Leg_room_service") AS avg_business_legroom
      , AVG("Inflight_wifi_service") AS avg_business_wifi
    FROM AirlinePassengerSatisfaction
    WHERE "Class" = 'Business'
      AND satisfaction = 'satisfied'
),
eco_loyal_customers AS (
    SELECT
        "Gender"
      , "Age"
      , "Type_of_Travel"
      , "Flight_Distance"
      , "Seat_comfort" AS seat_comfort
      , "Inflight_entertainment" AS inflight_entertainment
      , "On_board_service" AS onboard_service
      , "Leg_room_service" AS legroom_service
      , "Inflight_wifi_service" AS wifi_service
      , satisfaction
    FROM AirlinePassengerSatisfaction
    WHERE "Class" = 'Eco'
      AND "Customer_Type" = 'Loyal Customer'
),
scored_passengers AS (
    SELECT
        e."Gender"
      , e."Age"
      , e."Type_of_Travel"
      , e."Flight_Distance"
      , e.satisfaction

      -- Composite similarity score to benchmark satisfied Business passengers
      , ROUND(
            (
                (e.seat_comfort * 1.0 / NULLIF(b.avg_business_seat_comfort, 0)) * 20
              + (e.inflight_entertainment * 1.0 / NULLIF(b.avg_business_entertainment, 0)) * 20
              + (e.onboard_service * 1.0 / NULLIF(b.avg_business_onboard_service, 0)) * 20
              + (e.legroom_service * 1.0 / NULLIF(b.avg_business_legroom, 0)) * 20
              + (e.wifi_service * 1.0 / NULLIF(b.avg_business_wifi, 0)) * 20
            )
          , 2
        ) AS upsell_score_100
    FROM eco_loyal_customers e
    CROSS JOIN business_benchmark b
)
SELECT
    CASE
        WHEN "Age" BETWEEN 18 AND 35 THEN '18_35'
        WHEN "Age" BETWEEN 36 AND 50 THEN '36_50'
        WHEN "Age" BETWEEN 51 AND 65 THEN '51_65'
        ELSE '66_plus'
    END AS age_band
  , "Gender"
  , "Type_of_Travel"
  , COUNT(*) AS passenger_count
  , ROUND(AVG(upsell_score_100), 2) AS avg_upsell_score
  , ROUND(AVG("Flight_Distance"), 2) AS avg_flight_distance
  , SUM(CASE WHEN upsell_score_100 >= 80 THEN 1 ELSE 0 END) AS high_potential_targets
  , ROUND(
        SUM(CASE WHEN upsell_score_100 >= 80 THEN 1.0 ELSE 0 END) / COUNT(*) * 100
      , 2
    ) AS high_potential_target_pct
FROM scored_passengers
GROUP BY
    age_band
  , "Gender"
  , "Type_of_Travel"
ORDER BY avg_upsell_score DESC;

-- EXPECTED INTERPRETATION
-- - Segments with high average scores are better premium upsell audiences.
-- - This can support CRM audience creation and targeted campaigns.