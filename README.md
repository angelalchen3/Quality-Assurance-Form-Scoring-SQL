# QA Evaluation SQL Models

This repository contains anonymized SQL models that demonstrate how to transform
question-level quality assurance (QA) evaluations into analytics-ready views.  
The examples show how to standardize raw evaluation data, build dimension mappings,
and pivot question-level results into a single row per evaluation.

All scripts use synthetic naming conventions and do not contain proprietary information.

---

## Purpose

These SQL models illustrate:

- How to normalize and standardize raw QA evaluation data
- How to map categories and question indices to a consistent question identifier
- How to pivot question-level rows into Q1–Q16 columns
- How to compute gross and maximum evaluation scores
- How to model form-specific QA scoring logic (e.g., “Form A”)
- How to structure data warehouse layers (source → dim → mart)

The goal is to demonstrate production-quality SQL and modeling design suitable
for analytics engineering or data engineering workloads.

---

## Repository Structure

### **1. `evaluation_by_room_view.sql`**
Creates a standardized evaluation-level view that:

- Normalizes timestamps and field names  
- Exposes evaluator, agent, category, and scoring metadata  
- Provides one row per *question* within an evaluation  
- Serves as the base “mart” model for downstream transformations  

This model transforms raw source fields into clean, warehouse-friendly columns.

---

### **2. `evaluation_question_map.sql`**
Builds a dimension mapping that assigns:

- A stable `question_id` (1–16)  
- A standardized column label (`q1`, `q2`, …)  
- Canonical `max_score` values  

This dimension ensures consistency when pivoting evaluations,  
even if the source system uses multiple categories or question indices.

---

### **3. `evaluation_pivot_lost_stolen.sql`**
Produces a wide, evaluation-level dataset with:

- Columns `q1` through `q16` representing each scored question  
- Calculated `gross_score` (sum of question scores)  
- Calculated `maximum_score` (sum of available max scores)  
- One row per evaluation ID  

This is a typical structure used in BI dashboards, agent scorecards,
and quality program reporting.

---

## Data Model Flow

The SQL models follow a simple but realistic data-warehouse pattern:
Source System → Standardized Evaluation View → Question Mapping → Pivoted Form


1. **Standardize** raw question-level data  
2. **Map** categories and question indices into stable identifiers  
3. **Pivot** into an evaluation-wide format  
4. **Score** each evaluation using transformed fields  

This showcases how QA datasets can be modeled end-to-end for reporting.

---

## Technology

All queries are written using **Snowflake SQL**, including:
- CTEs (`WITH` clauses)  
- Conditional aggregation  
- Row numbering and dimension mapping  
- Pivot-style `CASE` logic for wide-format transformation  
- Warehouse-style naming conventions (`fact_`, `dim_`, `mart_`)

---

## Notes

- All schemas, tables, and field names have been anonymized.  
- No customer, employee, or internal business data is present.  
- Examples are intended strictly to demonstrate SQL modeling practices.


