COPY address
    FROM 'C:\\Users\\ThawThaw\\Desktop\\CZ4033\\Datas\\Address.csv'
    DELIMITER ','
    CSV HEADER
;

COPY online_transaction
    FROM 'C:\\Users\\ThawThaw\\Desktop\\CZ4033\\Datas\\OnlineTrans.csv'
    DELIMITER ','
    CSV HEADER
;

COPY star
    FROM 'C:\\Users\\ThawThaw\\Desktop\\CZ4033\\Datas\\Actor.csv'
    DELIMITER ','
    CSV HEADER
;

-- Question 11 --
select cin.cinema_id,addr.state_name, SUM(Tr.total_price) as TotalSale, RANK() OVER (ORDER BY SUM(Tr.total_price) DESC) as Cinema_Rank
from cinema as cin, total_sales_ft as F, address as addr, transaction as Tr
where cin.address_id = addr.address_id AND F.cinema_id = cin.cinema_id AND Tr.transaction_id = F.transaction_id
GROUP BY cin.cinema_id,addr.state_name

-- Question 12 -- 
SELECT Dir.director_name,mov.movie_title, SUM(Tr.total_price) as TotalSale, RANK() OVER (ORDER BY SUM(Tr.total_price) DESC) as Movie_rank 
FROM director as Dir, movie as Mov, total_sales_ft as F, transaction as Tr, customer as c
WHERE  Dir.director_id = Mov.director_id AND F.movie_id = Mov.movie_id AND c.customer_id = F.customer_id And Tr.transaction_id = F.transaction_id
AND EXTRACT(YEAR FROM c.dob) > 1986 
GROUP BY Dir.director_name, mov.movie_title;

-- Question 13 --

SELECT onlineT.browser, addr.state_name, COUNT(Tr.transaction_id) as TotalTrans, RANK() OVER (PARTITION BY addr.state_name
ORDER BY COUNT(Tr.transaction_id) DESC) 
FROM online_transaction as onlineT, total_sales_ft as F, transaction as Tr, address as addr, cinema as cin
WHERE onlineT.online_transaction_id = F.transaction_id and onlineT.online_transaction_id = Tr.transaction_id 
and addr.address_id = cin.address_id and cin.cinema_id = F.cinema_id
GROUP BY onlineT.browser, addr.state_name;

-- Question 14 --
create view female_temp AS 
SELECT mov.movie_title, c.gender, COUNT(t.ticket_id) as NumOfTickets
FROM movie as mov, transaction as Tr, total_sales_ft as F, customer as c, ticket as t
WHERE EXTRACT(YEAR FROM mov.released_date) = 2016 and c.gender = 'Female' and mov.movie_id = F.movie_id and c.customer_id = F.customer_id and Tr.transaction_id = F.transaction_id
and t.transaction_id = Tr.transaction_id
GROUP BY mov.movie_title, c.gender
order by NumOfTickets DESC

create view male_temp AS 
SELECT mov.movie_title, c.gender, COUNT(t.ticket_id) as NumOfTickets
FROM movie as mov, transaction as Tr, total_sales_ft as F, customer as c, ticket as t
WHERE  EXTRACT(YEAR FROM mov.released_date) = 2016 and c.gender = 'Male' and mov.movie_id = F.movie_id and c.customer_id = F.customer_id and Tr.transaction_id = F.transaction_id
and t.transaction_id = Tr.transaction_id
GROUP BY mov.movie_title, c.gender
order by NumOfTickets DESC

SELECT * 
FROM female_temp
SELECT *
FROM male_temp

-- Question 15 --

SELECT cin.cinema_id, COUNT(t.ticket_id) as TotalTicket 
FROM Cinema as cin, transaction as Tr, total_sales_ft as F, Ticket as t
WHERE EXTRACT(YEAR FROM Tr.transaction_date) >= 2011 and EXTRACT(YEAR FROM Tr.transaction_date) <= 2016 AND cin.cinema_id = F.cinema_id 
AND Tr.transaction_id = F.transaction_id AND t.transaction_id = F.transaction_id
GROUP BY cin.cinema_id
ORDER BY TotalTicket DESC
LIMIT 5


-- Question 16 -- 
SELECT  A.Week2016,A.TotalPrice, A.WeeklySales, AVG(A.WeeklySales)  OVER (ORDER BY A.Week2016 ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as MovingWeekSales
FROM (
SELECT SUM(Tr.total_price) AS TotalPrice, EXTRACT(WEEK FROM Tr.transaction_date) as Week2016, SUM(Tr.total_price) as WeeklySales
FROM  transaction as Tr , total_sales_ft as F
WHERE EXTRACT(YEAR FROM Tr.transaction_date) = 2016 and Tr.transaction_id = F.transaction_id
GROUP BY Tr.total_price, Tr.transaction_date
) as A
GROUP BY  A.Week2016,A.TotalPrice, A.WeeklySales


-- Question 17 --

SELECT  A.Week2016,A.TotalPrice, A.WeeklySales, AVG(A.WeeklySales) OVER (ORDER BY AVG(A.WeeklySales)DESC ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as MovingWeekSales
FROM (
SELECT SUM(Tr.total_price) AS TotalPrice, EXTRACT(WEEK FROM Tr.transaction_date) as Week2016, SUM(Tr.total_price) as WeeklySales
FROM  transaction as Tr , total_sales_ft as F
WHERE EXTRACT(YEAR FROM Tr.transaction_date) = 2016 and Tr.transaction_id = F.transaction_id
GROUP BY Tr.total_price, Tr.transaction_date
) as A
GROUP BY  A.Week2016,A.TotalPrice, A.WeeklySales
LIMIT 3; 

-- Question 18 -- 
SELECT  A.Week2011TO2016,A.YEAR2011TO2016,A.TotalPrice, A.WeeklySales, AVG(A.WeeklySales) OVER (ORDER BY AVG(A.WeeklySales)DESC ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as MovingWeekSales
FROM (
SELECT SUM(Tr.total_price) AS TotalPrice, EXTRACT(WEEK FROM Tr.transaction_date) as Week2011TO2016,EXTRACT(YEAR FROM Tr.transaction_date) as YEAR2011TO2016, SUM(Tr.total_price) as WeeklySales
FROM  transaction as Tr , total_sales_ft as F
WHERE EXTRACT(YEAR FROM Tr.transaction_date)<= 2016 and EXTRACT(YEAR FROM Tr.transaction_date)>=2011 and Tr.transaction_id = F.transaction_id
GROUP BY Tr.total_price, Tr.transaction_date
) as A
GROUP BY  A.Week2011TO2016,A.YEAR2011TO2016,A.TotalPrice, A.WeeklySales
LIMIT 3; 
