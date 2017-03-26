CREATE TABLE address(
	address_id VARCHAR(15) NOT NULL,
	state_name VARCHAR(255) NOT NULL,
	country VARCHAR(25) NOT NULL,
	CONSTRAINT pk_address_id PRIMARY KEY (address_id)
);

CREATE TABLE cinema (
	cinema_id VARCHAR(10) NOT NULL,
	address_id VARCHAR(10) NOT NULL,
	CONSTRAINT pk_cinema_id PRIMARY KEY (cinema_id),
	CONSTRAINT fk_address_id_cinema FOREIGN KEY(address_id) REFERENCES address(address_id)
);

CREATE TABLE director(
	director_id VARCHAR(10) NOT NULL,
	director_name VARCHAR(255) NOT NULL,
	director_dob DATE NOT NULL,
	director_gender CHAR(10) NOT NULL,
	CONSTRAINT pk_director_id PRIMARY KEY(director_id)
);

CREATE TABLE star(
	star_id VARCHAR(10) NOT NULL,
	star_name VARCHAR(255) NOT NULL,
	star_dob DATE NOT NULL,
	star_gender CHAR(10) NOT NULL,
	CONSTRAINT pk_star_id PRIMARY KEY(star_id)
);

CREATE TABLE movie( 
	movie_id VARCHAR(10) NOT NULL, 
	released_date VARCHAR(10) NOT NULL, 
	movie_language VARCHAR(255) NOT NULL, 
	movie_total_cost FLOAT NOT NULL, 
	movie_country VARCHAR(255) NOT NULL, 
	movie_title VARCHAR(255) NOT NULL, 
	movie_genre VARCHAR(255) NOT NULL,
	director_id VARCHAR(10) NOT NULL,
	star_id VARCHAR(10) NOT NULL,
	CONSTRAINT pk_movie_id PRIMARY KEY(movie_id),
	CONSTRAINT fk_director_id_movie FOREIGN KEY (director_id) REFERENCES director(director_id),
	CONSTRAINT fk_star_id_movie FOREIGN KEY (star_id) REFERENCES star(star_id)
);

CREATE TABLE customer( 
	customer_id VARCHAR(20) NOT NULL, 
	address_id VARCHAR(10) NOT NULL,
	customer_name char(30) NOT NULL, 
	dob VARCHAR(10) NOT NULL,
	gender char(10) NOT NULL, 
	CONSTRAINT pk_customer_id PRIMARY KEY(customer_id),
	CONSTRAINT fk_address_id_customer FOREIGN KEY(address_id) REFERENCES address(address_id)
);

CREATE TABLE transaction(
	transaction_id VARCHAR(20) NOT NULL, 
	transaction_method VARCHAR(10) NOT NULL,
	payment_method VARCHAR(20) NOT NULL,
	transaction_date DATE NOT NULL,
	transaction_time TIME NOT NULL,
	total_price INT NOT NULL,
	CONSTRAINT pk_transaction_id PRIMARY KEY(transaction_id) 
); 

CREATE TABLE online_transaction(
	online_transaction_id VARCHAR(20) NOT NULL, 
	system_id VARCHAR(255) NOT NULL, 
	browser VARCHAR(255) NOT NULL,
	CONSTRAINT fk_transaction_id_online_transaction FOREIGN KEY(online_transaction_id) REFERENCES transaction(transaction_id)
);  

CREATE TABLE offline_transaction(
	offline_transaction_id VARCHAR(20) NOT NULL, 
	CONSTRAINT fk_transaction_id_offline_transaction FOREIGN KEY(offline_transaction_id) REFERENCES transaction(transaction_id)
); 

CREATE TABLE promotion( 
	promotion_id VARCHAR(10) NOT NULL, 
	promo_description VARCHAR(255) NOT NULL, 
	discount VARCHAR(10) NOT NULL, 
	CONSTRAINT pk_promotion_id PRIMARY KEY(promotion_id)
); 

CREATE TABLE ticket(
	ticket_id VARCHAR(20) NOT NULL,
	seating_row VARCHAR(255) NOT NULL, 
	seat_number INT NOT NULL, 
	transaction_id VARCHAR(20) NOT NULL,
	CONSTRAINT pk_ticket_id PRIMARY KEY(ticket_id),
	CONSTRAINT fk_transaction_id_ticket FOREIGN KEY(transaction_id) REFERENCES transaction(transaction_id)
);

CREATE TABLE showing(
	showing_id VARCHAR(10) NOT NULL,
	showing_date DATE NOT NULL, 
	showing_time TIME NOT NULL, 
	CONSTRAINT pk_showing_id  PRIMARY KEY(showing_id)
);

CREATE TABLE hall(
	hall_id VARCHAR(10) NOT NULL,
	hall_size VARCHAR(12) NOT NULL, 
	CONSTRAINT pk_hall_id  PRIMARY KEY(hall_id)
);

CREATE TABLE total_sales_ft (
	transaction_id VARCHAR(20) NOT NULL,
	customer_id VARCHAR(20) NOT NULL,
	movie_id VARCHAR(10) NOT NULL,
	cinema_id VARCHAR(10) NOT NULL,
	promotion_id VARCHAR(10),
	showing_id VARCHAR(10) NOT NULL,
	hall_id VARCHAR(10) NOT NULL,
	CONSTRAINT fk_transaction_id FOREIGN KEY(transaction_id) REFERENCES transaction(transaction_id),
	CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
	CONSTRAINT fk_movie_id FOREIGN KEY(movie_id) REFERENCES movie(movie_id),
	CONSTRAINT fk_promotion_id FOREIGN KEY(promotion_id) REFERENCES promotion(promotion_id),
	CONSTRAINT fk_cinema_id FOREIGN KEY(cinema_id) REFERENCES cinema(cinema_id),
	CONSTRAINT fk_showing_id FOREIGN KEY(showing_id) REFERENCES showing(showing_id),
	CONSTRAINT fk_hall_id FOREIGN KEY(hall_id) REFERENCES hall(hall_id)
);