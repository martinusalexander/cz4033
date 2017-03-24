-- question 2 -- 
SELECT * 
FROM crosstab('
     select extract(month from t.transaction_date)::bigint as dobmon, t.transaction_method as tmethod, trunc(sum(t.total_price),2)::int as totalsales
     from total_sales_ft as f, transaction as t, customer as c
     where f.transaction_id = t.transaction_id and f.customer_id = c.customer_id
     group by dobmon,rollup(extract(year from t.transaction_date), tmethod)') AS final_result(yearr bigint, Transaction_Method text);