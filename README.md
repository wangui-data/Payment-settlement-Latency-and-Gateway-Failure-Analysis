# payment-settlement-latency-and-gateway-failure-analysis
End-to-end fintech data analytics evaluating payment gateway failure rates, transaction settlement latency, and cross-border processing efficiency using SQL and Power BI.
#  Fintech Payment Settlement Latency Analysis

# 📌 Executive Summary

This capstone project evaluates end-to-end data analytics and querying capabilities within a simulated fintech ecosystem  across 6 core domains. Using a relational database spanning 3 tables, the assessment bridges foundational data extraction with advanced financial intelligence, risk management, and window-function analytics.

---

# Key Focus Areas & Analytical Scope

**- Customer Demographics & Value**: Evaluates foundational user distribution (country, KYC status) alongside advanced customer segmentation, lifetime value (LTV) drivers, and cohort acquisition retention.

**- Payment Performance & Operations**: Analyzes systemic transaction health, examining success rates, payment method efficiencies, monthly volume trends, processor reliability, and settlement velocity across channels.

**- Transaction Dynamics**: Explores transactional behavior by type, dominant spending categories for debit volume, liquidity risk (negative balances), and annual customer net positions (credits versus debits).

**- Risk, Fraud, & Compliance**: Focuses on platform security by quantifying flagged transactions, identifying high-risk spending categories/channels, isolating unverified KYC high-value anomalies, and detecting abnormal refund behaviors.

**- Revenue & Fee Optimization**: Measures top-line fee generation, effective fee rates, high-yield payment methods, and micro-segment profitability across customer tiers and geographies.

**- Advanced Data Engineering**: Utilizes complex analytical techniques—including window functions for global country-level rankings, velocity metrics (time between first and second payments), and cohort conversion modeling.


The goal is to identify patterns that may indicate high transaction volumes, unusual payment behavior, fraud risk, or shifting customer lifetime value.
---




# Business Observations and Findings

### 1. Bank transfers are the dominant payment method.
Bank transfers account for the largest share of payment activity in the dataset, indicating that customers rely heavily on bank-based payments. This suggests that **bank-transfer reliability and settlement performance are particularly important to the overall payment experience.**

### 2. Completed transactions dominate, but failed and non-finalized payments represent a meaningful share.
Out of 246 transactions, 172 (70%) were completed, while 22 (9%) failed, 19 (7.7%) were refunded, 18 (7.3%) were cancelled, and 11 (4.5%) remained pending. Although most transactions were completed, roughly 30% did not result in a completed payment, **highlighting an opportunity to investigate payment failures, cancellations, refunds, and pending settlements.**

### 3. Payment value is concentrated among a small number of customers, with a notable KYC risk signal.
The customer with the highest payment value is based in Nigeria and is a Standard-tier customer whose KYC status is unverified. Among the top 10 customers by completed payment value, 5 are verified, 4 are unverified, and 1 is pending, meaning that **half of the highest-value customers do not currently have a verified KYC status. This may warrant closer compliance and risk monitoring for high-value transactions.**

### 4. Customer acquisition peaked in 2022, but acquisition declined afterward.
2022 recorded the highest customer acquisition, with 73 registered customers, 66 of whom remain active. This was followed by 2021 with 51 customers and 2020 with 49. Acquisition then dropped to 27 customers in 2023, suggesting new-customer growth declined after the 2022 peak. This could prompt the business to **investigate what drove the 2022 acquisition spike and whether those strategies can be replicated.**

###  5. Standard-tier customers have the highest average lifetime value.
The Standard customer tier has the highest average lifetime value at **52,791**, indicating that Standard-tier customers generate greater long-term value on average than customers in the other tiers. This could support further **investigation into what behaviors, transaction patterns, or customer characteristics are driving the higher value of Standard-tier customers.**
