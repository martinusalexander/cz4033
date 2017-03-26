COPY address
    FROM '/home/martinus/Documents/School/cz4033/Address.csv'
    DELIMITER ','
    CSV HEADER
;

COPY cinema
    FROM '/home/martinus/Documents/School/cz4033/Cinema.csv'
    DELIMITER ','
    CSV HEADER
;

COPY customer
    FROM '/home/martinus/Documents/School/cz4033/Customer.csv'
    DELIMITER ','
    CSV HEADER
;

COPY hall
    FROM '/home/martinus/Documents/School/cz4033/Hall.csv'
    DELIMITER ','
    CSV HEADER
;

COPY director
    FROM '/home/martinus/Documents/School/cz4033/Director.csv'
    DELIMITER ','
    CSV HEADER
;

COPY star
    FROM '/home/martinus/Documents/School/cz4033/Actor.csv'
    DELIMITER ','
    CSV HEADER
;

COPY movie
    FROM '/home/martinus/Documents/School/cz4033/Movie.csv'
    DELIMITER ','
    CSV HEADER
;

COPY transaction
    FROM '/home/martinus/Documents/School/cz4033/TransTable.csv'
    DELIMITER ','
    CSV HEADER
;


COPY offline_transaction
    FROM '/home/martinus/Documents/School/cz4033/OfflineTrans.csv'
    DELIMITER ','
    CSV HEADER
;

COPY online_transaction
    FROM '/home/martinus/Documents/School/cz4033/OnlineTrans.csv'
    DELIMITER ','
    CSV HEADER
;

COPY ticket
    FROM '/home/martinus/Documents/School/cz4033/Ticket_1.csv'
    DELIMITER ','
    CSV HEADER
;

COPY ticket
    FROM '/home/martinus/Documents/School/cz4033/Ticket_2.csv'
    DELIMITER ','
    CSV HEADER
;

COPY ticket
    FROM '/home/martinus/Documents/School/cz4033/Ticket_3.csv'
    DELIMITER ','
    CSV HEADER
;

COPY ticket
    FROM '/home/martinus/Documents/School/cz4033/Ticket_4.csv'
    DELIMITER ','
    CSV HEADER
;


COPY promotion
    FROM '/home/martinus/Documents/School/cz4033/Promotion.csv'
    DELIMITER ','
    CSV HEADER
;

COPY showing
    FROM '/home/martinus/Documents/School/cz4033/Showing.csv'
    DELIMITER ','
    CSV HEADER
;

COPY total_sales_ft
    FROM '/home/martinus/Documents/School/cz4033/FactTable.csv'
    DELIMITER ','
    CSV HEADER
;