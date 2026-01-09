-- qa_question_map_v.sql
-- Purpose:
--   Portfolio example: build a question mapping dimension used to pivot
--   question-level QA evaluations into a wide format (q1..qN).
--   Synthetic schema + placeholder fields; illustrative only.

CREATE OR REPLACE VIEW portfolio_dim.qa_question_map_v AS
WITH cleaned AS (
    SELECT
        category_name,
        question_index,
        question_text,
        MAX(TRY_TO_NUMBER(question_max_score)) AS question_max_score
    FROM portfolio_raw.qa_evaluation_questions_src
    WHERE evaluation_form = 'FORM_A'              -- placeholder form identifier
      AND TRY_TO_NUMBER(question_max_score) > 0
    GROUP BY
        category_name,
        question_index,
        question_text
),
keyed AS (
    SELECT
        category_name,
        question_index,
        question_text,
        question_max_score,

        -- Deterministic identifier (stable across refreshes given same inputs)
        MD5(TO_VARCHAR(category_name) || '|' ||
            TO_VARCHAR(question_index) || '|' ||
            TO_VARCHAR(question_text)
        ) AS question_key
    FROM cleaned
),
ordered AS (
    SELECT
        category_name,
        question_index,
        question_text,
        question_max_score,
        question_key,

        -- Assign a sequential question_id for pivot convenience (q1..qN)
        ROW_NUMBER() OVER (ORDER BY category_name, question_index, question_key) AS question_id
    FROM keyed
)
SELECT
    category_name,
    question_index,
    question_text,
    question_key,
    question_id,
    'q' || TO_VARCHAR(question_id) AS q_col,
    question_max_score
FROM ordered;
