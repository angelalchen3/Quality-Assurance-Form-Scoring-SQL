-- evaluation_question_map.sql
-- Purpose:
--   Build a lookup table that assigns a stable question_id and q_col
--   (e.g., q1, q2, q3...) to each question in a specific evaluation form.
--   Used when pivoting question-level evaluation data into a wide format.
--   All schemas, table names, and form names are anonymized.

CREATE OR REPLACE VIEW analytics.dim.evaluation_question_map (
    category_name,
    question_index,
    question_text,
    question_id,
    q_col,
    max_score
) AS
WITH cleaned AS (
    SELECT
        category_name,
        question_index,
        question_text,
        MAX(TRY_TO_NUMBER(max_score)) AS max_score
    FROM analytics.source_evaluation_by_room
    WHERE evaluation_form = 'Form A'
      AND max_score <> 0
    GROUP BY
        category_name,
        question_index,
        question_text
),
assigned AS (
    SELECT
        category_name,
        question_index,
        question_text,
        ROW_NUMBER() OVER (
            ORDER BY category_name, question_index
        ) AS question_id,
        'q' || TO_VARCHAR(
            ROW_NUMBER() OVER (
                ORDER BY category_name, question_index
            )
        ) AS q_col,
        max_score
    FROM cleaned
)
SELECT
    category_name,
    question_index,
    question_text,
    question_id,
    q_col,
    max_score
FROM assigned;
