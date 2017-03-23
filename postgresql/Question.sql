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
FROM crosstab('SELECT DATE_TRUNC(''month'', t.transaction_date) AS Month, 
                t.transaction_method AS Transaction_Method,
                TRUNC(SUM(t.total_price), 2) AS Total_Sales
     FROM total_sales_ft AS ft, transaction AS t, customer AS c
     WHERE ft.transaction_id = t.transaction_id 
        AND ft.customer_id = c.customer_id
     GROUP BY ROLLUP(EXTRACT(year FROM DATE_TRUNC(''month'', t.transaction_date))), Transaction_Method') 
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