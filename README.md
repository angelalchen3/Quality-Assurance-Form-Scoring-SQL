# QA Evaluation SQL Models (Portfolio)

This repository contains **portfolio-built SQL models** that demonstrate how
question-level quality assurance (QA) evaluation data can be transformed into
analytics-ready datasets.

The examples focus on **data modeling patterns**, **SQL transformation logic**,
and **warehouse design** commonly used when working with QA or assessment-style
datasets. All schemas, objects, and values are **synthetic placeholders** created
solely for demonstration purposes.

---

## Purpose

These SQL models illustrate how to:

- Normalize and standardize raw, question-level evaluation data  
- Map categories and question indices to stable identifiers  
- Pivot long-format evaluation data into a wide, evaluation-level structure  
- Compute aggregate scores (gross score and maximum possible score)  
- Design reusable warehouse layers (source → dimension → mart)  

The goal is to showcase **analytics engineering–style SQL**, emphasizing clarity,
maintainability, and modeling discipline rather than any specific system
implementation.

---

## Repository Structure

### 1. `qa_evaluation_questions_v.sql`

Creates a standardized, question-level evaluation view that:

- Normalizes timestamps and field names  
- Uses identifier-based fields (e.g., `agent_id`, `evaluator_id`) rather than names  
- Produces one row per *question* per evaluation  
- Serves as the canonical source for downstream transformations  

This model demonstrates how raw evaluation records can be shaped into a clean,
warehouse-friendly contract.

---

### 2. `qa_question_map_v.sql`

Builds a dimension table that assigns:

- A deterministic question key  
- A sequential `question_id` used for pivoting (`q1`, `q2`, …)  
- Canonical maximum score values per question  

This mapping layer ensures consistent pivots even when questions originate from
multiple categories or indices in the source data.

---

### 3. `qa_evaluation_pivot_v.sql`

Produces a wide, evaluation-level dataset with:

- Columns `q1` through `q16` representing individual question scores  
- A calculated `gross_score` (sum of available question scores)  
- A calculated `maximum_score` (sum of maximum possible scores)  
- One row per evaluation  

This structure mirrors patterns commonly used in BI dashboards, scorecards,
and downstream analytical reporting.

---

## Data Model Flow

The models follow a simplified warehouse pattern:

**Raw Evaluation Records → Standardized Question View → Question Mapping → Pivoted Evaluation Mart**

1. Standardize raw question-level records  
2. Map questions to stable identifiers  
3. Pivot long-format data into a wide evaluation structure  
4. Aggregate scores for reporting and analysis  

This demonstrates an end-to-end approach to modeling QA-style datasets.

---

## Technology

All queries are written in **Snowflake SQL**, using:

- Common table expressions (`WITH`)  
- Conditional aggregation  
- Window functions for identifier assignment  
- Pivot-style `CASE` logic  
- Warehouse-style naming conventions (`raw_`, `dim_`, `mart_`)  

---

## Notes on Data & Scope

- All schemas, tables, columns, and values are **synthetic placeholders**  
- No employer datasets, customer data, or internal business logic are included  
- Any thresholds or configurations are illustrative only  

These examples exist solely to demonstrate **SQL modeling techniques and design
patterns**.
