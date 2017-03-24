--Question 1
SELECT * 
FROM crosstab('SELECT EXTRACT(year FROM t.transaction_date)::TEXT AS Year, 
                c.gender AS Gender,
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, transaction AS t, customer AS c
     WHERE ft.transaction_id = t.transaction_id 
        AND ft.customer_id = c.customer_id
     GROUP BY Year, Gender ORDER BY Year,Gender')  
AS final_result(row_name TEXT, Female NUMERIC, Male NUMERIC);

--Question 2
SELECT * 
FROM crosstab('WITH t AS (
                    SELECT *, to_char(transaction_date, ''YYYY'') AS Year,
                        to_char(transaction_date, ''MM'') AS Month
                    FROM transaction )
     SELECT (t.Year || coalesce (''-'' || t.Month, ''''))::TEXT AS Time, 
        t.transaction_method AS Transaction_Method,
        TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, t, customer AS c
     WHERE ft.transaction_id = t.transaction_id 
        AND ft.customer_id = c.customer_id
     GROUP BY ROLLUP(t.Year, t.Month), Transaction_Method ORDER BY Time, Transaction_Method;') 
AS final_result(Month TEXT, OfflineTransaction NUMERIC, OnlineTransaction NUMERIC);

--Question 3
CREATE OR REPLACE VIEW movie_day AS
SELECT *,  
        CASE WHEN EXTRACT(dow FROM s.showing_date) = 0 THEN 'Weekends'
             WHEN EXTRACT(dow FROM s.showing_date) = 1 THEN 'Weekdays'
             WHEN EXTRACT(dow FROM s.showing_date) = 2 THEN 'Weekdays'
             WHEN EXTRACT(dow FROM s.showing_date) = 3 THEN 'Weekdays'
             WHEN EXTRACT(dow FROM s.showing_date) = 4 THEN 'Weekdays'
             WHEN EXTRACT(dow FROM s.showing_date) = 5 THEN 'Weekdays'
             WHEN EXTRACT(dow FROM s.showing_date) = 6 THEN 'Weekends'
             ELSE 'Unknown'
        END AS dow
FROM showing AS s;

SELECT * 
FROM crosstab('SELECT m.movie_genre::TEXT AS Genre, 
                md.dow AS Day_of_Week,
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, transaction t, movie_day AS md, movie AS m
     WHERE ft.showing_id = md.showing_id 
        AND ft.movie_id = m.movie_id
        AND ft.transaction_id = t.transaction_id
     GROUP BY Genre, Day_of_Week ORDER BY Genre, Day_of_Week') 
AS final_result(Genre TEXT, Weekdays NUMERIC, Weekends NUMERIC);

-- Question 4
SELECT * 
FROM crosstab('SELECT c.gender::TEXT AS Gender, 
                p.promo_description AS Promotion,
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, promotion AS p, customer AS c, transaction AS t
     WHERE ft.promotion_id = p.promotion_id 
        AND ft.customer_id = c.customer_id
        AND ft.transaction_id = t.transaction_id
        AND EXTRACT(year FROM t.transaction_date)::INT = 2016
     GROUP BY Gender, Promotion ORDER BY Gender, Promotion')  
AS final_result(Gender TEXT, "Happy Hour" NUMERIC, Senior NUMERIC, Student NUMERIC);

-- Question 5
CREATE OR REPLACE VIEW NoTickets AS
SELECT transaction.transaction_id AS transaction_id, COUNT(*) AS NoTickets
FROM transaction, ticket
WHERE transaction.transaction_id = ticket.transaction_id
GROUP BY transaction.transaction_id;

SELECT * 
FROM crosstab('SELECT nt.NoTickets::NUMERIC AS NoTickets,
                c.gender::TEXT AS Gender, 
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, customer AS c, transaction AS t, NoTickets AS nt
     WHERE ft.customer_id = c.customer_id
        AND ft.transaction_id = t.transaction_id 
        AND t.transaction_id = nt.transaction_id
        AND EXTRACT(year FROM t.transaction_date) = 2016
     GROUP BY NoTickets, Gender ORDER BY NoTickets, Gender')  
AS final_result(N_Tickets NUMERIC, Female NUMERIC, Male NUMERIC);

-- Question 6
CREATE OR REPLACE VIEW movie_hour AS
SELECT *,
        CASE WHEN EXTRACT(hour FROM s.showing_time) = 9 THEN 'Morning'
             WHEN EXTRACT(hour FROM s.showing_time) = 10 THEN 'Morning'
             WHEN EXTRACT(hour FROM s.showing_time) = 11 THEN 'Morning'
             WHEN EXTRACT(hour FROM s.showing_time) = 12 THEN 'Afternoon'
             WHEN EXTRACT(hour FROM s.showing_time) = 13 THEN 'Afternoon'
             WHEN EXTRACT(hour FROM s.showing_time) = 14 THEN 'Afternoon'
             WHEN EXTRACT(hour FROM s.showing_time) = 15 THEN 'Afternoon'
             WHEN EXTRACT(hour FROM s.showing_time) = 16 THEN 'Afternoon'
             WHEN EXTRACT(hour FROM s.showing_time) = 17 THEN 'Afternoon'
             WHEN EXTRACT(hour FROM s.showing_time) = 18 THEN 'Night'
             WHEN EXTRACT(hour FROM s.showing_time) = 19 THEN 'Night'
             WHEN EXTRACT(hour FROM s.showing_time) = 20 THEN 'Night'
             WHEN EXTRACT(hour FROM s.showing_time) = 21 THEN 'Night'
             WHEN EXTRACT(hour FROM s.showing_time) = 22 THEN 'Night'
             ELSE 'Unknown'
        END AS dayhour
FROM showing AS s;

SELECT * 
FROM crosstab('SELECT c.gender::TEXT AS Gender, 
                mh.dayhour AS Dayhour,
                SUM(nt.NoTickets) AS Total_Ticket
     FROM total_sales_ft AS ft, customer AS c, movie_hour AS mh, transaction AS t, NoTickets AS nt
     WHERE ft.customer_id = c.customer_id 
        AND ft.showing_id = mh.showing_id
        AND ft.transaction_id = t.transaction_id
        AND ft.transaction_id = nt.transaction_id
        AND EXTRACT(year FROM t.transaction_date) = 2016
     GROUP BY Gender, Dayhour ORDER BY Gender, Dayhour') 
AS final_result(Gender TEXT, Afternoon NUMERIC, Morning NUMERIC, Night NUMERIC);

-- Question 7
SELECT * 
FROM crosstab('SELECT a.state_name::TEXT AS State, 
                EXTRACT(year FROM t.transaction_date)::TEXT AS Year,
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, transaction AS t, movie AS m, cinema AS c, director AS d, address AS a
     WHERE ft.transaction_id = t.transaction_id 
        AND ft.movie_id = m.movie_id
        AND ft.cinema_id = c.cinema_id 
        AND c.address_id = a.address_id
        AND m.director_id = d.director_id
        AND d.director_name = ''Christopher Nolan''
        AND EXTRACT(year FROM t.transaction_date) <= 2016 
        AND EXTRACT(year FROM t.transaction_date) >= 2011
     GROUP BY State, Year ORDER BY State, Year')  
AS final_result(State TEXT, Year_2011 NUMERIC, Year_2012 NUMERIC, Year_2013 NUMERIC, Year_2014 NUMERIC, Year_2015 NUMERIC, Year_2016 NUMERIC);

-- Question 8
SELECT * 
FROM crosstab('SELECT m.movie_genre::TEXT AS Genre, 
                c.gender AS Gender,
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, customer AS c, transaction AS t, movie AS m, star AS s
     WHERE ft.customer_id = c.customer_id 
        AND ft.transaction_id = t.transaction_id
        AND ft.movie_id = m.movie_id 
        AND m.star_id = s.star_id
        AND s.star_name = ''Tom Hanks''
     GROUP BY Genre, Gender ORDER BY Genre, Gender') 
AS final_result(Genre TEXT, Female NUMERIC, Male NUMERIC);

-- Question 9
SELECT * 
FROM crosstab('SELECT a.state_name::TEXT AS State, 
                h.hall_size AS HallSize,
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, cinema as c, address as a, hall as h, transaction AS t
     WHERE ft.transaction_id = t.transaction_id
        AND ft.cinema_id = c.cinema_id 
        AND c.address_id = a.address_id
        AND ft.hall_id = h.hall_id
     GROUP BY State, HallSize ORDER BY State, HallSize') 
AS final_result(State TEXT, LargeSizeHall NUMERIC, MidSizeHall NUMERIC, SmallSizeHall NUMERIC);

-- Question 10 -- 

create view temp as 
select c.gender , t.transaction_id, date_part('year', t.transaction_date::date)- date_part('year',c.dob::date) as custage ,
case 
  when date_part('year', t.transaction_date::date) - date_part('year',c.dob::date) between 1 and 10 then 'Children'
  when date_part('year', t.transaction_date::date) - date_part('year',c.dob::date) between 10 and 20 then 'Teenager'
  when date_part('year', t.transaction_date::date) - date_part('year',c.dob::date) between 20 and 40 then 'Adult'
  when date_part('year', t.transaction_date::date) - date_part('year',c.dob::date) > 40 then 'Older Adult'
  end as agegroup
from customer as c, transaction as t, total_sales_ft as f
where c.customer_id = f.customer_id and t.transaction_id = f.transaction_id

select *
from 
crosstab ('select temp.gender as gender,temp.custage as Age, temp.agegroup as agegroup, sum(t.total_price) as totalsales 
            from temp, transaction as t
            where temp.transaction_id = t.transaction_id
            group by cube(temp.gender),rollup(Age,agegroup)','VALUES (''Children''),(''Teenager''), (''Adult''), (''Older Adult'') ')as ct(gender TEXT,Age TEXT, "Children" TEXT, "Teenager" TEXT, "Adult" TEXT, "Older Adult" TEXT) ; 

-- Question 11 --
select cin.cinema_id,addr.state_name, SUM(tr.total_price) as TotalSale, RANK() OVER (ORDER BY SUM(tr.total_price) DESC) as Cinema_Rank
from cinema as cin, total_sales_ft as f, address as addr, transaction as tr
where cin.address_id = addr.address_id AND f.cinema_id = cin.cinema_id AND tr.transaction_id = f.transaction_id
GROUP BY cin.cinema_id,addr.state_name;

-- Question 12 -- 
SELECT Dir.director_name,mov.movie_title, SUM(tr.total_price) as TotalSale, RANK() OVER (ORDER BY SUM(tr.total_price) DESC) as Movie_rank 
FROM director as Dir, movie as Mov, total_sales_ft as f, transaction as tr, customer as c
WHERE  Dir.director_id = Mov.director_id AND f.movie_id = Mov.movie_id AND c.customer_id = f.customer_id And tr.transaction_id = f.transaction_id
AND EXTRACT(YEAR FROM c.dob::DATE) > 1986 
GROUP BY Dir.director_name, mov.movie_title;

-- Question 13 --
SELECT online_transaction.browser, addr.state_name, COUNT(tr.transaction_id) as total_transaction, RANK() OVER (PARTITION BY addr.state_name
ORDER BY COUNT(tr.transaction_id) DESC) 
fROM online_transaction as online_transaction, total_sales_ft as f, transaction as tr, address as addr, cinema as cin
WHERE online_transaction.online_transaction_id = f.transaction_id and online_transaction.online_transaction_id = tr.transaction_id 
and addr.address_id = cin.address_id and cin.cinema_id = f.cinema_id
GROUP BY online_transaction.browser, addr.state_name;

-- Question 14 --
SELECT * 
FROM (
    SELECT mov.movie_title, c.gender, COUNT(t.ticket_id) as NumOfTickets, RANK() OVER (PARTITION BY c.gender ORDER BY COUNT(t.ticket_id) DESC) as orderby_ticket_sold
    FROM movie as mov, transaction as tr, total_sales_ft as f, customer as c, ticket as t
    WHERE EXTRACT(YEAR FROM mov.released_date::DATE) = 2016 AND mov.movie_id = f.movie_id AND c.customer_id = f.customer_id 
    AND tr.transaction_id = f.transaction_id
    AND t.transaction_id = tr.transaction_id
    GROUP BY  mov.movie_title,c.gender) AS temp
WHERE temp.orderby_ticket_sold <= 10; 

-- Question 15 --
SELECT cin.cinema_id, COUNT(t.ticket_id) as total_ticket 
FROM cinema as cin, transaction as tr, total_sales_ft as f, ticket as t
WHERE EXTRACT(YEAR FROM tr.transaction_date::DATE) >= 2011 and EXTRACT(YEAR FROM tr.transaction_date::DATE) <= 2016 AND cin.cinema_id = f.cinema_id 
AND tr.transaction_id = f.transaction_id AND t.transaction_id = f.transaction_id
GROUP BY cin.cinema_id
ORDER BY total_ticket DESC
LIMIT 5;

-- Question 16 -- 

SELECT EXTRACT(WEEK FROM tr.transaction_date) AS week, SUM(tr.total_price) AS weekly_total, TRUNC(AVG(SUM(tr.total_price)) OVER ( ORDER BY EXTRACT(WEEK FROM tr.transaction_date)
    																					ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ),2) AS moving_average_weekly
FROM transaction as tr, total_sales_ft as f
WHERE tr.transaction_id = f.transaction_id AND EXTRACT(YEAR FROM tr.transaction_date::DATE) = 2016
GROUP BY EXTRACT(WEEK FROM tr.transaction_date);
                                                                                      
                                                                                      
-- Question 17 --
SELECT * 
FROM (
    SELECT EXTRACT(WEEK FROM tr.transaction_date) AS week,EXTRACT(YEAR FROM tr.transaction_date::DATE)as year, SUM(tr.total_price) AS weekly_total, 
    AVG(SUM(tr.total_price)) OVER ( ORDER BY EXTRACT(WEEK FROM tr.transaction_date) 
    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ) AS moving_average_weekly
    FROM transaction as tr, total_sales_ft as f
    WHERE tr.transaction_id = f.transaction_id AND EXTRACT(YEAR FROM tr.transaction_date::DATE) = 2016
    GROUP BY EXTRACT(WEEK FROM tr.transaction_date),EXTRACT(YEAR FROM tr.transaction_date::DATE)
    ) AS temp 
ORDER BY temp.moving_average_weekly DESC 
LIMIT 3; 
                                                  
-- Question 18 -- 
CREATE OR REPLACE VIEW largest_moving_sale_in_5_years AS(
SELECT *, RANK() OVER( PARTITION BY temp.state ORDER BY moving_average_weekly desc) as largest_moving_sale_rank
FROM (
    SELECT addr.state_name as state, EXTRACT(WEEK FROM tr.transaction_date) AS week,EXTRACT(YEAR FROM tr.transaction_date::DATE) as year, SUM(tr.total_price) AS weekly_total, 
    AVG(SUM(tr.total_price)) OVER (PARTITION BY addr.state_name ORDER BY EXTRACT(WEEK FROM tr.transaction_date) 
    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ) AS moving_average_weekly

    FROM transaction as tr, total_sales_ft as f, address as addr, cinema as cin
    WHERE tr.transaction_id = f.transaction_id AND EXTRACT(YEAR FROM tr.transaction_date::DATE) <= 2016 AND EXTRACT(YEAR FROM tr.transaction_date::DATE) >= 2011
    AND cin.address_id = addr.address_id AND cin.cinema_id = f.cinema_id
    GROUP BY  addr.state_name,EXTRACT(WEEK FROM tr.transaction_date),EXTRACT(YEAR FROM tr.transaction_date::DATE)
    ) AS temp
);
SELECT *
FROM largest_moving_sale_in_5_years
WHERE largest_moving_sale_rank = 1; 