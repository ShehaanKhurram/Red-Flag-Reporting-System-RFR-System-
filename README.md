# RFR System – Anonymous Red Flag Reporting System
A MySQL-based database project designed to manage anonymous reporting of issues in an organization. The system allows users to submit red flag reports without revealing their identity, enabling structured review and action by relevant departments.

# Project Overview
Designed and implemented a relational database for an anonymous reporting system.

Focused on data integrity, relational algebra, and query optimization.

Includes joins, nested queries, correlated queries, views, and stored procedures for effective data management.

# Database Design
Reporter – Stores anonymous report IDs and metadata
Department – Stores organizational departments
Category – Classifies report types
Report – Main table for reports and submission details
Reviewer – Maintains reviewers who handle reports
Reviewer_Action – Tracks actions taken on reports
User_Feedback – Stores feedback and closure info

# Features
Supports anonymous report submission.

Handles reviewer assignments and actions.

Implements nested & correlated queries for data analysis.

Uses views and stored procedures for modular and reusable operations.
