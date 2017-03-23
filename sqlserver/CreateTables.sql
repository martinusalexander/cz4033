CREATE TABLE Address(
	AddressID varchar(10) NOT NULL,
	StateName VARCHAR(255) NOT NULL,
	Country VARCHAR(25) NOT NULL,
	CONSTRAINT pk_AddressID PRIMARY KEY (AddressID)
);

CREATE TABLE Cinema (
	CinemaID varchar(10) NOT NULL,
	AddressID VARCHAR(10) NOT NULL,
	CONSTRAINT pk_CinemaID PRIMARY KEY (CinemaID),
	CONSTRAINT fk_AddressID_Cinema FOREIGN KEY(AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE Movie( 
	MovieID varchar(10) NOT NULL, 
	ReleasedDate varchar(10) NOT NULL, 
	MovieLanguage VARCHAR(255) NOT NULL, 
	MovieTotalCost FLOAT NOT NULL, 
	MovieCountry VARCHAR(255) NOT NULL, 
	MovieTitle VARCHAR(255) NOT NULL, 
	MovieGenre VARCHAR(255) NOT NULL, 
	CONSTRAINT pk_MovieID PRIMARY KEY(MovieID)
); 
CREATE TABLE Person(
	PersonID varchar(10) NOT NULL,
	Name VARCHAR(255) NOT NULL, 
	DOB DATE NOT NULL, 
	Gender CHAR(10) NOT NULL,
	CONSTRAINT pk_PersonID PRIMARY KEY(PersonID)
);

CREATE TABLE Director(
	DirectorID varchar(10) NOT NULL,
	Dir_name varchar(255) NOT NULL,
	Dir_DOB date NOT NULL,
	Dir_gender char(10) NOT NULL,
	MovieID varchar(10) NOT NULL,
	CONSTRAINT fk_MovieID_Director FOREIGN KEY(MovieID) REFERENCES Movie(MovieID)
);

CREATE TABLE Star(
	PersonID varchar(10) NOT NULL,
	Act_name varchar(255) NOT NULL,
	Act_DOB date NOT NULL,
	Act_gender char(10) NOT NULL,
	MovieID varchar(10) NOT NULL,
	CONSTRAINT fk_MovieID_Star FOREIGN KEY(MovieID) REFERENCES Movie(MovieID)
);

CREATE TABLE Customer( 
	CustomerID VARCHAR(20) NOT NULL, 
	AddressID varchar(10) NOT NULL,
	CustomerName char(30) NOT NULL, 
	DOB varchar(10) NOT NULL,
	Gender char(10) NOT NULL, 
	CONSTRAINT pk_CustomerID_Customer PRIMARY KEY(CustomerID),
	CONSTRAINT fk_AddressID_Customer FOREIGN KEY(AddressID) REFERENCES Address(AddressID)
);


CREATE TABLE OnlineTransaction(
	OnlineTransactionID VARCHAR(20) NOT NULL, 
	System_ID NVARCHAR(255) NOT NULL, 
	Browser NVARCHAR(255) NOT NULL, 
	CONSTRAINT pk_OnlineTransactionID Primary KEY(OnlineTransactionID) 
);  

CREATE TABLE OfflineTransaction(
	OfflineTransactionID VARCHAR(20) NOT NULL, 
	TransactionDate Date NOT NULL,
	TransactionTime Time Not NULL,
	TotalPrice varchar(10) NOT NULL,
	CONSTRAINT pk_OfflineTransactionID PRIMARY KEY(OfflineTransactionID) 
); 

CREATE TABLE Promotion( 
	PromotionID varchar(10) NOT NULL, 
	PromoDescription VARCHAR(255) NOT NULL, 
	Discount varchar(10) NOT NULL, 
	CONSTRAINT pk_PromotionID PRIMARY KEY(PromotionID)
); 

CREATE TABLE Ticket(
	TicketID VARCHAR(10) NOT NULL,
	SeatingRow VARCHAR(255) NOT NULL, 
	SeatNumber INT NOT NULL, 
	TicketPrice FLOAT NOT NULL, 
	CONSTRAINT pk_TicketID PRIMARY KEY(TicketID)
);

CREATE TABLE Showing(
	ShowingID varchar(10) NOT NULL,
	ShowingDate DATE NOT NULL, 
	ShowingTIme TIME NOT NULL, 
	CONSTRAINT pk_ShowingID  PRIMARY KEY(ShowingID)
);

CREATE TABLE Hall(
	HallID varchar(10) NOT NULL,
	HallSize varchar(10) NOT NULL, 
	CONSTRAINT pk_HallID  PRIMARY KEY(HallID)
);

CREATE TABLE TotalSalesFT (
	OnlineTransactionID VARCHAR(20) NOT NULL, 
	OfflineTransactionID VARCHAR(20) NOT NULL,
	CustomerID VARCHAR(20) NOT NULL,
	MovieID varchar(10) NOT NULL,
	CinemaID varchar(10) NOT NULL,
	PromotionID varchar(10),
	ShowingID varchar(10) NOT NULL,
	HallID varchar(10) NOT NULL,
	TicketID VARCHAR(10) NOT NULL,
	constraint fk_PersonID foreign key(PersonID) references Person(PersonID),
	CONSTRAINT fk_OnlineTransactionID FOREIGN KEY(OnlineTransactionID) REFERENCES OnlineTransaction(OnlineTransactionID),
	CONSTRAINT fk_OfflineTransactionID FOREIGN KEY(OfflineTransactionID) REFERENCES OfflineTransaction(OfflineTransactionID),
	CONSTRAINT fk_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT fk_MovieID FOREIGN KEY(MovieID) REFERENCES Movie(MovieID),
	CONSTRAINT fk_PromotionID FOREIGN KEY(PromotionID) REFERENCES Promotion(PromotionID),
	CONSTRAINT fk_CinemaID FOREIGN KEY(CinemaID) REFERENCES Cinema(CinemaID),
	CONSTRAINT fk_ShowingID FOREIGN KEY(ShowingID) REFERENCES Showing(ShowingID),
	CONSTRAINT fk_HallID FOREIGN KEY(HallID) REFERENCES Hall(HallID),
	CONSTRAINT fk_TicketID FOREIGN KEY(TicketID) REFERENCES Ticket(TicketID),
	--CONSTRAINT fk_OnlineTransactionID FOREIGN KEY(OnlineTransactionID) REFERENCES OnlineTransaction(OnlineTransactionID)
);