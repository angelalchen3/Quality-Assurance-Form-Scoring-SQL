-- qa_evaluation_questions_v.sql
-- Purpose:
--   Portfolio example: standardize question-level QA evaluations into an analytics-ready view.
--   Synthetic schema + placeholder fields; illustrative only.

CREATE OR REPLACE VIEW portfolio_mart.qa_evaluation_questions_v AS
SELECT
    -- lineage
    load_datetime                         AS load_ts,
    file_name                             AS source_file,

    -- identifiers (use IDs, not names)
    evaluation_id,
    interaction_id,
    evaluator_id,
    agent_id,
    queue_id,

    -- timing
    TO_DATE(evaluation_date)              AS evaluation_date,
    evaluation_timestamp                  AS evaluation_ts,

    -- form/question metadata
    evaluation_form,
    category_name,
    category_index,
    question_index,
    question_label,
    question_text,

    -- scoring
    TRY_TO_NUMBER(evaluation_score)       AS score,
    TRY_TO_NUMBER(question_max_score)     AS question_max_score,

    -- optional flags (keep generic)
    IFF(comments IS NOT NULL, 1, 0)       AS has_comment_flag,
    IFF(auto_fail_flag = TRUE, 1, 0)      AS auto_fail_flag

FROM portfolio_raw.qa_evaluation_questions_src;
