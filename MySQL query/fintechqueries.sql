-- customers registered per country
select 
	country,
	count(*)as customer_count
from users
group by country;

-- the breakdown of users by KYC status
select
	kyc_status,
	count(*) as no_of_users
from users
group by kyc_status;

--  customer tier with the highest average lifetime value
select 
	tier,
	avg(total_lifetime_value) AS avg_lifetime_value
from users
group by tier
order by avg_lifetime_value desc;

-- customers acquired each year, and what share is still  active
select 
	EXTRACT(YEAR FROM joined_date) as acquisition_year,
    COUNT(customer_id) as total_customers,
    SUM(CASE WHEN is_active = 'TRUE' THEN 1 ELSE 0 END) AS active_count,
    ROUND(
        100.0 * SUM(CASE WHEN is_active = 'TRUE' THEN 1 ELSE 0 END) / COUNT(customer_id), 
        2
    ) AS share_still_active_percentage
from users
group by acquisition_year
order by acquisition_year;

--  top 10 customers by total completed payment volume, Include  their tier and KYC status.
select
	u.customer_id,
    u.first_name,
    u.tier,
    u.kyc_status,
    SUM(p.net_amount) AS total_completed_payment_volume
from users u
join 
    payments p ON u.customer_id = p.customer_id
WHERE 
    p.status = 'completed'
group by 
	u.customer_id,
    u.first_name,
    u.tier,
    u.kyc_status
order by total_completed_payment_volume DESC
limit 10;

-- overall payment success rate broken down by status
select 
    status,
    COUNT(payment_id) AS total_transactions,
    ROUND(
        100.0 * COUNT(payment_id) / SUM(COUNT(payment_id)) OVER (), 
        2
    ) AS success_rate
FROM 
    payments
GROUP BY 
    status
ORDER BY 
    total_transactions DESC;
	
    --  total and average payment amount by payment method
select 
	payment_method,
    sum(net_amount) as total_payment,
    avg(net_amount) as average_payment
from 
	payments
group by 
	payment_method;
    
-- monthly payment volume and count trend over the full date range
 select
    DATE_FORMAT(created_at, '%Y-%m') AS payment_month, 
    COUNT(payment_id) AS total_payment_count,
    SUM(net_amount) AS total_payment_volume
from 
    payments
group by 
    payment_month
order by 
    payment_month ASC;
    
-- payment processor with the best success rate and lowest average fee
select 
	processor,
     ROUND(
         SUM(
            CASE 
                WHEN LOWER(status) = 'completed' THEN 1 
                ELSE 0 
            END
        ) * 100.0 / COUNT(*), 
        2
    ) AS success_rate,
    ROUND(AVG(fee), 2) AS average_fee
from payments
group by processor
order by success_rate DESC, average_fee ASC;

-- count and total amount of transactions by transaction type
select 
	transaction_type,
    count(transaction_id) as transaction_count,
    sum(amount) as total_amount
from transactions
group by transaction_type;

-- spending categories that drive the most debit transaction volume
select
    category,
    sum(amount) as total_debit
from transactions
where transaction_type = 'debit'
group by category
order by total_debit desc;

-- share of transactions that resulted into an overdraft after the transaction
select 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN balance_after < 0 THEN 1 ELSE 0 END) AS negative_balance_count,
    ROUND(
        100.0 * SUM(CASE WHEN balance_after < 0 THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS share_resulting_in_negative_balance_percentage
from transactions;

-- each customer, calculate their net position (total credits minus total debits)  for 2024. Include their name and tier.
select
	u.first_name,
    u.tier,
    SUM(case when t.transaction_type = 'Credit' THEN t.amount 
            when t.transaction_type = 'Debit' THEN -t.amount 
            else 0 
        end
    ) AS net_position
from 
    users u
join 
    transactions t ON u.customer_id = t.customer_id
where 
    t.value_date >= '2024-01-01' 
    and t.value_date < '2025-01-01'
group by
   u.customer_id, 
   u.first_name, 
   u.tier;

-- transactions that are flagged, and the total flagged amount
select
	count(*) as flagged,
    sum(amount) as total_flagged_amt
from transactions
where is_flagged = 'TRUE';

--  spending categories and channels with the highest fraud flag rate
select 
	category,
    channel,
    count(*) AS total_transactions,
    sum(case when is_flagged = 'TRUE' then 1 else 0 end) AS flagged_transactions,
    (sum(case when is_flagged = 'TRUE' then 1 else 0 end) * 1.0 / count(*)) AS fraud_flag_rate
from 
    transactions
group by 
    category,
	channel
order by 
    fraud_flag_rate DESC;
    
    -- customers with unverified or pending KYC who have completed high value payments above 5,000
select distinct
    u.customer_id,
    u.first_name,
    u.tier,
    u.kyc_status,
    p.net_amount AS payment_amount
from 
	users u
join 
    payments p ON u.customer_id = p.customer_id
where 
    u.kyc_status IN ('unverified', 'pending')
    AND p.net_amount > 5000
order by 
  p.net_amount DESC;
    
-- customers whose refunds account for more than 20% of their total  transactions.
select 
    u.customer_id,
    u.first_name,
    u.tier,
    count(t.transaction_id) AS total_transactions,
    sum(case when t.transaction_type = 'refund' then 1 else 0 end) AS refund_count,
    (SUM(case when t.transaction_type = 'refund' then 1 else 0 end) * 100.0 / count(t.transaction_id)) AS refund_percentage
from 
    users u
join 
    transactions t ON u.customer_id = t.customer_id
group by
    u.customer_id,
    u.first_name,
    u.tier
having 
    (sum(case when t.transaction_type = 'refund' then 1 else 0 end) * 100.0 / count(t.transaction_id)) > 20
order by
    refund_percentage DESC;
    
-- total fee revenue collected and the effective fee rate per month
select 
    date_format(created_at, '%Y-%m') AS transaction_month,
    count(payment_id) AS total_transactions,
    sum(amount) AS total_transaction_volume,
    sum(fee) AS total_fee_revenue,
    (sum(fee) * 100.0 / sum(amount)) AS effective_fee_rate_percentage
from 
    payments	
group by
   date_format(created_at, '%Y-%m') 
order by
    transaction_month ASC;

-- payment method generates the most fee revenue
select
	payment_method,
    sum(fee) as total_fee_revenue
from 
	payments
group by
	payment_method
order by
	total_fee_revenue DESC;
    
--  fee revenue per customer segment (tier × country). Show the top 10  combinations.
select 
    u.tier,
    u.country,
    count(p.payment_id) AS total_payments,
    sum(p.amount) AS total_payment_volume,
    sum(p.fee) AS total_fee_revenue
from 
    users u
join 
    payments p ON u.customer_id = p.customer_id
group by
    u.tier,
    u.country
order by
    total_fee_revenue DESC
limit 10;

-- customers rank  by total payment volume within each country using a window  function
with customer_volumes AS (
    select 
        u.customer_id,
        u.first_name,
        u.country,
        SUM(p.amount) AS total_payment_volume
    from 
        users u
    join 
        payments p ON u.customer_id = p.customer_id
    group by 
        u.customer_id,
        u.first_name,
		u.country
)
select 
    customer_id,
    first_name,
    country,
    total_payment_volume,
    rank() over (partition by country order by total_payment_volume DESC) AS volume_rank
from 
    customer_volumes
order by 
    country ASC, 
    volume_rank ASC;
    
-- what is average number of days between a customer's first and second  completed payment?
with ordered_payments AS (
    select 
        customer_id,
        created_at AS payment_date,
        row_number() over(partition by customer_id order by created_at ASC) AS payment_sequence
    from 
        payments
    where 
        status = 'completed' 
),
first_two_payments AS (
    select 
        p1.customer_id,
        p1.payment_date AS first_payment_date,
        p2.payment_date AS second_payment_date
    from 
        ordered_payments p1
    join 
        ordered_payments p2 ON p1.customer_id = p2.customer_id
    where 
        p1.payment_sequence = 1 
        AND p2.payment_sequence = 2
)
select 
    avg(DATEDIFF(second_payment_date, first_payment_date)) AS avg_days_between_1st_and_2nd
from 
    first_two_payments;

-- the monthly signup cohort has the highest rate of customers who went on to  complete at least one payment
with customer_cohorts AS (
    select 
        u.customer_id,
        DATE_FORMAT(u.joined_date, '%Y-%m') AS signup_month
    from 
        users u
),
customer_payment_status AS (
    select 
        uu.customer_id,
        uu.signup_month,
        max(case when p.status = 'completed' then 1 else 0 end) AS has_paid
    from 
        customer_cohorts uu
    left join 
        payments p ON uu.customer_id = p.customer_id
    group by 
        uu.customer_id, 
        uu.signup_month
)
select 
    signup_month,
    count(customer_id) AS total_signups,
    sum(has_paid) AS customers_who_paid,
    (sum(has_paid) * 100.0 / count(customer_id)) AS conversion_rate_percentage
from 
    customer_payment_status
group by
    signup_month
order by 
    conversion_rate_percentage DESC;