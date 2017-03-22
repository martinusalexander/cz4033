CREATE TABLE address(
	address_id VARCHAR(15) NOT NULL,
	state_name VARCHAR(255) NOT NULL,
	country VARCHAR(255) NOT NULL,
	CONSTRAINT pk_address_id PRIMARY KEY (address_id)
);

CREATE TABLE cinema (
	cinema_id VARCHAR(10) NOT NULL,
	address_id VARCHAR(10) NOT NULL,
	CONSTRAINT pk_cinema_id PRIMARY KEY (cinema_id),
	CONSTRAINT fk_address_id_cinema FOREIGN KEY(address_id) REFERENCES address(address_id)
);

CREATE TABLE movie( 
	movie_id VARCHAR(10) NOT NULL, 
	released_date VARCHAR(10) NOT NULL, 
	movie_language VARCHAR(255) NOT NULL, 
	movie_total_cost FLOAT NOT NULL, 
	movie_country VARCHAR(255) NOT NULL, 
	movie_title VARCHAR(255) NOT NULL, 
	movie_genre VARCHAR(255) NOT NULL, 
	CONSTRAINT pk_movie_id PRIMARY KEY(movie_id)
); 

CREATE TABLE person(
	person_id VARCHAR(10) NOT NULL,
	name VARCHAR(255) NOT NULL, 
	dob DATE NOT NULL, 
	gender CHAR(10) NOT NULL,
	CONSTRAINT pk_person_id PRIMARY KEY(person_id)
);

CREATE TABLE director(
	person_id VARCHAR(10) NOT NULL,
	movie_id VARCHAR(10) NOT NULL,
	CONSTRAINT fk_person_id_director FOREIGN KEY(person_id) REFERENCES person(person_id),
	CONSTRAINT fk_movie_id_director FOREIGN KEY(movie_id) REFERENCES movie(movie_id)
);

CREATE TABLE actor(
	person_id VARCHAR(10) NOT NULL,
	movie_id VARCHAR(10) NOT NULL,
	CONSTRAINT fk_person_id_actor FOREIGN KEY(person_id) REFERENCES person(person_id),
	CONSTRAINT fk_movie_id_actor FOREIGN KEY(movie_id) REFERENCES movie(movie_id)
);

CREATE TABLE customer( 
	customer_id VARCHAR(20) NOT NULL, 
	address_id VARCHAR(10) NOT NULL,
	customer_name char(30) NOT NULL, 
	dob VARCHAR(10) NOT NULL,
	gender char(10) NOT NULL, 
	---CONSTRAINT pk_customer_id PRIMARY KEY(customer_id),
	CONSTRAINT pk_customer_id_customer PRIMARY KEY(customer_id),
	CONSTRAINT fk_address_id_customer FOREIGN KEY(address_id) REFERENCES address(address_id)
);


CREATE TABLE online_transaction(
	online_transaction_id VARCHAR(20) NOT NULL, 
	system_id VARCHAR(255) NOT NULL, 
	browser VARCHAR(255) NOT NULL, 
	CONSTRAINT pk_online_transaction_id Primary KEY(online_transaction_id) 
);  

CREATE TABLE offline_transaction(
	offline_transaction_id VARCHAR(20) NOT NULL, 
	transaction_date Date NOT NULL,
	transaction_time Time Not NULL,
	total_price Money NOT NULL,
	CONSTRAINT pk_offline_transaction_id PRIMARY KEY(offline_transaction_id) 
); 

CREATE TABLE promotion( 
	promotion_id VARCHAR(10) NOT NULL, 
	promo_description VARCHAR(255) NOT NULL, 
	discount DECIMAL NOT NULL, 
	--promotion_start_date DATETIME NOT NULL, 
	--promotion_end_date DATETIME NOT NULL, 
	CONSTRAINT pk_promotion_id PRIMARY KEY(promotion_id)
); 



CREATE TABLE ticket(
	ticket_id VARCHAR(10) NOT NULL,
	seating_row VARCHAR(255) NOT NULL, 
	seat_number INT NOT NULL, 
	ticket_price FLOAT NOT NULL, 
	CONSTRAINT pk_ticket_id PRIMARY KEY(ticket_id)
);

CREATE TABLE showing(
	showing_id VARCHAR(10) NOT NULL,
	showing_date DATE NOT NULL, 
	showing_time TIME NOT NULL, 
	CONSTRAINT pk_showing_id  PRIMARY KEY(showing_id)
);

CREATE TABLE hall(
	hall_size_id VARCHAR(10) NOT NULL,
	hall_size VARCHAR(12) NOT NULL, 
	CONSTRAINT pk_hall_id  PRIMARY KEY(hall_id)
);

CREATE TABLE total_sales_ft (
	online_transaction_id VARCHAR(10) NOT NULL, 
	offline_transaction_id VARCHAR(10) NOT NULL,
	customer_id VARCHAR(20) NOT NULL,
	movie_id VARCHAR(10) NOT NULL,
	cinema_id VARCHAR(10) NOT NULL,
	promotion_id VARCHAR(10),
	showing_id VARCHAR(10) NOT NULL,
	hall_id VARCHAR(10) NOT NULL,
	ticket_id VARCHAR(10) NOT NULL,
	CONSTRAINT fk_online_transaction_id FOREIGN KEY(online_transaction_id) REFERENCES online_transaction(online_transaction_id),
	CONSTRAINT fk_offline_transaction_id FOREIGN KEY(offline_transaction_id) REFERENCES offline_transaction(offline_transaction_id),
	CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
	CONSTRAINT fk_movie_id FOREIGN KEY(movie_id) REFERENCES movie(movie_id),
	CONSTRAINT fk_promotion_id FOREIGN KEY(promotion_id) REFERENCES promotion(promotion_id),
	CONSTRAINT fk_cinema_id FOREIGN KEY(cinema_id) REFERENCES cinema(cinema_id),
	CONSTRAINT fk_showing_id FOREIGN KEY(showing_id) REFERENCES showing(showing_id),
	CONSTRAINT fk_hall_id FOREIGN KEY(hall_id) REFERENCES hall(hall_id),
	CONSTRAINT fk_ticket_id FOREIGN KEY(ticket_id) REFERENCES ticket(ticket_id)
	--CONSTRAINT fk_online_transaction_id FOREIGN KEY(online_transaction_id) REFERENCES online_transaction(online_transaction_id)
);