--How many different nodes make up the Data Bank network?
select distinct node_id ,count(distinct'node_id') from customer_nodes group by node_id;
SELECT count(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;
--How many nodes are there in each region?
select region_name.regions , count ('node_id.customer_nodes') from regions inner join region_id on region_id.customer_nodes=region_id.regions group by region_name.regions;
SELECT region_id,
       region_name,
       count('node_id') AS node_count
FROM customer_nodes inner join regions using (region_id)
GROUP BY region_id,region_name;
--How many customers are divided among the regions?
SELECT region_id,
       region_name,
       count(DISTINCT customer_id) AS customer_count
FROM customer_nodes
INNER JOIN regions USING(region_id)
GROUP BY region_id , region_name;

--Determine the total amount of transactions for each region name.
select region_name , sum(txn_amount) from customer_transactions inner join customer_nodes using (customer_id)
inner join regions using (region_id) group by region_name;

--How long does it take on an average to move clients to a new node?
select round (avg(datediff( end_date ,start_date)),2) from customer_nodes ;


--What is the unique count and total amount for each transaction type?
select txn_type,
count(*), 
sum(txn_amount) 
from customer_transactions
group by txn_type;


--What is the average number and size of past deposits across all customers?
SELECT round(count(customer_id)/
               (SELECT count(DISTINCT customer_id)
                FROM customer_transactions)) AS average_deposit_count,
       concat('$', round(avg(txn_amount), 2)) AS average_deposit_amount
FROM customer_transactions
WHERE txn_type = "deposit";

--8. For each month - how many Data Bank customers make more than 1 deposit
and at least either 1 purchase or 1 withdrawal in a single month?

WITH transaction_count_per_month_cte AS
 ( SELECT customer_id,
          month(txn_date) AS txn_month,
          SUM(IF(txn_type="deposit", 1, 0)) AS deposit_count,
          SUM(IF(txn_type="withdrawal", 1, 0)) AS withdrawal_count,
          SUM(IF(txn_type="purchase", 1, 0)) AS purchase_count
   FROM customer_transactions
   GROUP BY customer_id,
            month(txn_date))
SELECT txn_month,
       count(DISTINCT customer_id) as customer_count
FROM transaction_count_per_month_cte
WHERE deposit_count>1
  AND (purchase_count = 1
       OR withdrawal_count = 1)
GROUP BY txn_month;





