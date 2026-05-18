-- =========================================================
-- File: 03_service_touchpoint_gap.sql
-- Project: HK Express Business Insights SQL Portfolio
-- Author: Stanley Yeung
-- Dataset: Airline-Passenger-Satisfaction.csv (https://www.kaggle.com/datasets/mysarahmadbhat/airline-passenger-satisfaction, Rows: 120,000, Licence: Public)
--
-- BUSINESS QUESTION
-- Which service touchpoints show the biggest gap between
-- satisfied and dissatisfied passengers?
--
-- WHY THIS MATTERS
-- This helps identify which parts of the passenger experience
-- most strongly separate happy customers from unhappy ones.
-- It supports prioritisation of improvement actions.
-- =========================================================

SELECT
    service_touchpoint
  , ROUND(satisfied_avg_score, 2) AS satisfied_avg_score
  , ROUND(dissatisfied_avg_score, 2) AS dissatisfied_avg_score
  , ROUND(score_gap, 2) AS score_gap
  , RANK() OVER (ORDER BY score_gap DESC) AS priority_rank
FROM (
    SELECT
        'Online boarding' AS service_touchpoint
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Online_boarding" END) AS satisfied_avg_score
      , AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Online_boarding" END) AS dissatisfied_avg_score
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Online_boarding" END)
        - AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Online_boarding" END) AS score_gap
    FROM AirlinePassengerSatisfaction

    UNION ALL

    SELECT
        'Inflight wifi service'
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Inflight_wifi_service" END)
      , AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Inflight_wifi_service" END)
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Inflight_wifi_service" END)
        - AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Inflight_wifi_service" END)
    FROM AirlinePassengerSatisfaction

    UNION ALL

    SELECT
        'Seat comfort'
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Seat_comfort" END)
      , AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Seat_comfort" END)
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Seat_comfort" END)
        - AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Seat_comfort" END)
    FROM AirlinePassengerSatisfaction

    UNION ALL

    SELECT
        'Inflight entertainment'
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Inflight_entertainment" END)
      , AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Inflight_entertainment" END)
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Inflight_entertainment" END)
        - AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Inflight_entertainment" END)
    FROM AirlinePassengerSatisfaction

    UNION ALL

    SELECT
        'Checkin service'
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Checkin_service" END)
      , AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Checkin_service" END)
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Checkin_service" END)
        - AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Checkin_service" END)
    FROM AirlinePassengerSatisfaction

    UNION ALL

    SELECT
        'Baggage handling'
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Baggage_handling" END)
      , AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Baggage_handling" END)
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Baggage_handling" END)
        - AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Baggage_handling" END)
    FROM AirlinePassengerSatisfaction

    UNION ALL

    SELECT
        'Food and drink'
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Food_and_drink" END)
      , AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Food_and_drink" END)
      , AVG(CASE WHEN satisfaction = 'satisfied' THEN "Food_and_drink" END)
        - AVG(CASE WHEN satisfaction <> 'satisfied' THEN "Food_and_drink" END)
    FROM AirlinePassengerSatisfaction
) ranked_touchpoints
ORDER BY priority_rank;

-- EXPECTED INTERPRETATION
-- - Higher score_gap means the touchpoint matters more in separating
--   satisfied vs dissatisfied passengers.
-- - The top-ranked items are the best candidates for CX improvement.