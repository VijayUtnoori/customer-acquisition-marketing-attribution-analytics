# 🚀 Customer Acquisition & Marketing Attribution Analytics

> **Status:** 🚧 **Work In Progress (WIP)** — *SQL Data Warehousing & Analytical Phase*

An end-to-end data analytics project evaluating marketing campaign ROI, channel acquisition efficiency, and multi-touch attribution modeling across a Star Schema architecture.

---

## 🏗️ Pipeline & Architecture

1. **Modeling & Export:** Star Schema designed in Power BI, clean tables exported to CSV via DAX Studio.
2. **Data Warehousing:** CSVs imported into SQL Server (SSMS) with date type optimizations.
3. **SQL Analytics (Current):** Writing T-SQL queries and CTEs to solve business attribution metrics.
4. **Dashboarding:** Final Power BI reporting linked to SQL Server analytical views.

---

## 🎯 Current Progress

- [x] Clean and model dimensions & facts in Power BI
- [x] Export dataset via DAX Studio to CSV format
- [x] Import schema into SQL Server (SSMS) with optimized `DATE` types
- [ ] **[CURRENT STEP]** Execute T-SQL exploratory and analytical query suite
- [ ] Build executive dashboards and document insights

---

## 📁 Repository Structure

```text
├── Dashboards/Data Modeling/  # Power BI files (.pbix) and data model schemas
├── Dataset/                   # Exported CSV tables for SQL import
├── Docs/                      # Data dictionaries and project documentation
├── EDA/                       # Exploratory Data Analysis scripts and notes
├── Insights/                  # Key business findings and executive summaries
├── Problem Statement/         # Core business goals and KPI requirements
└── Sql_analysis/              # T-SQL analytical queries and view creations
