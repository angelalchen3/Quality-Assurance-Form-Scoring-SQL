-- evaluation_pivot_lost_stolen.sql
-- Purpose:
--   Example of pivoting question-level QA evaluation data (1 row per question)
--   into a single row per evaluation with Q1–Q16 columns and gross/max scores.
--   All schemas, table names, and evaluation form names are anonymized.

CREATE OR REPLACE VIEW analytics.mart.evaluation_by_room_lost_stolen (
    evaluation_date,
    evaluation_form,
    evaluation_id,
    agent_name,
    team_name,
    q1,
    q2,
    q3,
    q4,
    q5,
    q6,
    q7,
    q8,
    q9,
    q10,
    q11,
    q12,
    q13,
    q14,
    q15,
    q16,
    gross_score,
    maximum_score
) AS
WITH base AS (
    SELECT
        e.evaluation_date,
        e.evaluation_form,
        e.evaluation_id,
        e.agent_name,
        e.team_name,
        k.question_id,
        e.evaluation_score,
        e.max_score
    FROM analytics.fact_evaluation_by_question e
    JOIN analytics.dim_evaluation_question_map k
      ON e.category_name  = k.category_name
     AND e.question_index = k.question_index
    WHERE e.evaluation_form = 'Form A'
)
SELECT
    ANY_VALUE(evaluation_date)  AS evaluation_date,
    ANY_VALUE(evaluation_form)  AS evaluation_form,
    evaluation_id,
    ANY_VALUE(agent_name)       AS agent_name,
    ANY_VALUE(team_name)        AS team_name,

    -- Q1..Q16 as columns
    MAX(CASE WHEN question_id =  1 THEN evaluation_score END) AS q1,
    MAX(CASE WHEN question_id =  2 THEN evaluation_score END) AS q2,
    MAX(CASE WHEN question_id =  3 THEN evaluation_score END) AS q3,
    MAX(CASE WHEN question_id =  4 THEN evaluation_score END) AS q4,
    MAX(CASE WHEN question_id =  5 THEN evaluation_score END) AS q5,
    MAX(CASE WHEN question_id =  6 THEN evaluation_score END) AS q6,
    MAX(CASE WHEN question_id =  7 THEN evaluation_score END) AS q7,
    MAX(CASE WHEN question_id =  8 THEN evaluation_score END) AS q8,
    MAX(CASE WHEN question_id =  9 THEN evaluation_score END) AS q9,
    MAX(CASE WHEN question_id = 10 THEN evaluation_score END) AS q10,
    MAX(CASE WHEN question_id = 11 THEN evaluation_score END) AS q11,
    COALESCE(
        MAX(
            CASE WHEN question_id = 12
                 THEN IFF(evaluation_score > 0, 10, 0)
            END
        ),
        0
    ) AS q12,
    MAX(CASE WHEN question_id = 13 THEN evaluation_score END) AS q13,
    MAX(CASE WHEN question_id = 14 THEN evaluation_score END) AS q14,
    MAX(CASE WHEN question_id = 15 THEN evaluation_score END) AS q15,
    MAX(CASE WHEN question_id = 16 THEN evaluation_score END) AS q16,

    -- Gross = sum of per-question scores
    (
        COALESCE(MAX(CASE WHEN question_id =  1 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  2 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  3 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  4 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  5 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  6 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  7 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  8 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  9 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 10 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 11 THEN evaluation_score END), 0) +
        COALESCE(
            MAX(
                CASE WHEN question_id = 12
                     THEN IFF(evaluation_score > 0, 10, 0)
                END
            ),
            0
        ) +
        COALESCE(MAX(CASE WHEN question_id = 13 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 14 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 15 THEN evaluation_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 16 THEN evaluation_score END), 0)
    ) AS gross_score,

    -- Maximum = sum of max per-question scores
    (
        COALESCE(MAX(CASE WHEN question_id =  1 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  2 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  3 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  4 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  5 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  6 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  7 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  8 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id =  9 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 10 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 11 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 12 THEN 10 END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 13 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 14 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 15 THEN max_score END), 0) +
        COALESCE(MAX(CASE WHEN question_id = 16 THEN max_score END), 0)
    ) AS maximum_score
FROM base
GROUP BY
    evaluation_id;
