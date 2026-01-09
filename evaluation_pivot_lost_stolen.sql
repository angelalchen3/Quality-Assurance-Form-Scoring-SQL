-- qa_evaluation_pivot_v.sql
-- Purpose:
--   Portfolio example: pivot question-level QA evaluations (1 row per question)
--   into a single row per evaluation with q1–q16 columns and gross/max scores.
--   Synthetic schema + placeholder fields; illustrative only.

CREATE OR REPLACE VIEW portfolio_mart.qa_evaluation_pivot_v AS
WITH base AS (
    SELECT
        e.evaluation_date,
        e.evaluation_form,
        e.evaluation_id,
        e.agent_id,
        e.team_id,
        k.question_id,
        e.score,
        e.question_max_score
    FROM portfolio_mart.qa_evaluation_questions_v e
    JOIN portfolio_dim.qa_question_map_v k
      ON e.category_name  = k.category_name
     AND e.question_index = k.question_index
),
pivoted AS (
    SELECT
        ANY_VALUE(evaluation_date) AS evaluation_date,
        ANY_VALUE(evaluation_form) AS evaluation_form,
        evaluation_id,
        ANY_VALUE(agent_id)        AS agent_id,
        ANY_VALUE(team_id)         AS team_id,

        -- q1..q16 as columns
        MAX(CASE WHEN question_id =  1 THEN score END) AS q1,
        MAX(CASE WHEN question_id =  2 THEN score END) AS q2,
        MAX(CASE WHEN question_id =  3 THEN score END) AS q3,
        MAX(CASE WHEN question_id =  4 THEN score END) AS q4,
        MAX(CASE WHEN question_id =  5 THEN score END) AS q5,
        MAX(CASE WHEN question_id =  6 THEN score END) AS q6,
        MAX(CASE WHEN question_id =  7 THEN score END) AS q7,
        MAX(CASE WHEN question_id =  8 THEN score END) AS q8,
        MAX(CASE WHEN question_id =  9 THEN score END) AS q9,
        MAX(CASE WHEN question_id = 10 THEN score END) AS q10,
        MAX(CASE WHEN question_id = 11 THEN score END) AS q11,
        MAX(CASE WHEN question_id = 12 THEN score END) AS q12,
        MAX(CASE WHEN question_id = 13 THEN score END) AS q13,
        MAX(CASE WHEN question_id = 14 THEN score END) AS q14,
        MAX(CASE WHEN question_id = 15 THEN score END) AS q15,
        MAX(CASE WHEN question_id = 16 THEN score END) AS q16,

        -- Gross score = sum of available question scores
        SUM(COALESCE(score, 0)) AS gross_score,

        -- Maximum score = sum of available max scores
        SUM(COALESCE(question_max_score, 0)) AS maximum_score
    FROM base
    GROUP BY evaluation_id
)
SELECT
    evaluation_date,
    evaluation_form,
    evaluation_id,
    agent_id,
    team_id,
    q1, q2, q3, q4, q5, q6, q7, q8,
    q9, q10, q11, q12, q13, q14, q15, q16,
    gross_score,
    maximum_score
FROM pivoted;
