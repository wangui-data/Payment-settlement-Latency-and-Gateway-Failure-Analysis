# payment-settlement-latency-and-gateway-failure-analysis
End-to-end fintech data analytics evaluating payment gateway failure rates, transaction settlement latency, and cross-border processing efficiency using SQL and Power BI.
#  Fintech Payment Settlement Latency Analysis


# business observations

### Bank transfers are the dominant payment method.
Bank transfers account for the largest share of payment activity in the dataset, indicating that customers rely heavily on bank-based payments. This suggests that **bank-transfer reliability and settlement performance are particularly important to the overall payment experience.**

### Completed transactions dominate, but failed and non-finalized payments represent a meaningful share.
Out of 246 transactions, 172 (70%) were completed, while 22 (9%) failed, 19 (7.7%) were refunded, 18 (7.3%) were cancelled, and 11 (4.5%) remained pending. Although most transactions were completed, roughly 30% did not result in a completed payment, **highlighting an opportunity to investigate payment failures, cancellations, refunds, and pending settlements.**

### Payment value is concentrated among a small number of customers, with a notable KYC risk signal.
The customer with the highest payment value is based in Nigeria and is a Standard-tier customer whose KYC status is unverified. Among the top 10 customers by completed payment value, 5 are verified, 4 are unverified, and 1 is pending, meaning that **half of the highest-value customers do not currently have a verified KYC status. This may warrant closer compliance and risk monitoring for high-value transactions.**

### Customer acquisition peaked in 2022, but acquisition declined afterward.
2022 recorded the highest customer acquisition, with 73 registered customers, 66 of whom remain active. This was followed by 2021 with 51 customers and 2020 with 49. Acquisition then dropped to 27 customers in 2023, suggesting a decline in new-customer growth after the 2022 peak. This could prompt the business to **investigate what drove the 2022 acquisition spike and whether those strategies can be replicated.**

###  Standard-tier customers have the highest average lifetime value.
The Standard customer tier has the highest average lifetime value at **52,791**, indicating that Standard-tier customers generate greater long-term value on average than customers in the other tiers. This could support further **investigation into what behaviors, transaction patterns, or customer characteristics are driving the higher value of Standard-tier customers.**
