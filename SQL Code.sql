################## CREATING THE TABLES FOR THE ENTITY SETS #######################
DROP TABLE IF EXISTS LibraryUser;

CREATE TABLE LibraryUser (
    UserID          INT NOT NULL UNIQUE AUTO_INCREMENT,
    FirstName		VARCHAR(255) NOT NULL,
    LastName		VARCHAR(255) NOT NULL,
    BirthDate		DATE NOT NULL,
    LoanerNumber 	VARCHAR(6) NOT NULL UNIQUE,
    UserStatus		ENUM('ACTIVE', 'TERMINATED', 'BLOCKED') NOT NULL,	# Can be ACTIVE, TERMINATED, or BLOCKED

    PRIMARY KEY(UserID)
);

DROP TABLE IF EXISTS Author;

CREATE TABLE Author (
    AuthorID		INT NOT NULL UNIQUE AUTO_INCREMENT,
    FirstName		VARCHAR(255) NOT NULL,
    LastName		VARCHAR(255) NOT NULL,
    Nationality    	VARCHAR(255),

    PRIMARY KEY(AuthorID)
);

DROP TABLE IF EXISTS Genre;

CREATE TABLE Genre (
    GenreID 		INT NOT NULL UNIQUE AUTO_INCREMENT,
    GenreType 		VARCHAR(255) NOT NULL,
    GenreSubtype 	VARCHAR(255) NOT NULL,

    PRIMARY KEY(GenreID)
);

DROP TABLE IF EXISTS Publisher;

CREATE TABLE Publisher (
    PublisherID		INT NOT NULL UNIQUE AUTO_INCREMENT,
    PublisherName	VARCHAR(255) NOT NULL UNIQUE,
    HQCountry 		VARCHAR(255),

    PRIMARY KEY(PublisherID)
);

DROP TABLE IF EXISTS Book;

CREATE TABLE Book (
    BookID		INT NOT NULL UNIQUE AUTO_INCREMENT,
    Title		VARCHAR(255) NOT NULL,
    ReleaseYear    	YEAR,
    PageCount		INT,
    TotalQuantity       INT NOT NULL,
    TextLanguage        VARCHAR(255),
    PublisherID		INT,
    GenreID		INT,

    PRIMARY KEY(BookID),
    FOREIGN KEY(PublisherID) REFERENCES Publisher(PublisherID) ON DELETE CASCADE,
    FOREIGN KEY(GenreID) REFERENCES Genre(GenreID) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Fine;

CREATE TABLE Fine (
    FineID		INTEGER NOT NULL UNIQUE AUTO_INCREMENT,
    Amount		DECIMAL(8, 2) NOT NULL,
    UserID		INTEGER NOT NULL,
    IssuedDate		DATE NOT NULL,
    PaymentStatus	ENUM('PAID', 'NOT PAID') NOT NULL,	# Can be PAID or NOT PAID

    PRIMARY KEY(FineID),
    FOREIGN KEY(UserID) REFERENCES LibraryUser(UserID) ON DELETE CASCADE ON UPDATE CASCADE	
);

######## CREATING ASSOCIATE IDENTITY TABLES ########

DROP TABLE IF EXISTS Loans;

CREATE TABLE Loans (
    UserID		INT NOT NULL,
    BookID		INT NOT NULL,
    LoanedDate   	DATE NOT NULL,
    UntilDate   	DATE NOT NULL,	# Must always be 30 days after the LoanedDate
    ReturnedDate	DATE,
    LoanedStatus 	ENUM('LOANED', 'FINED', 'RETURNED') NOT NULL,	# Can be LOANED, FINED, or RETURNED

    PRIMARY KEY(UserID, BookID, LoanedDate),
    FOREIGN KEY(UserID) REFERENCES LibraryUser(UserID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(BookID) REFERENCES Book(BookID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Reserves;

CREATE TABLE Reserves (
    UserID		INT NOT NULL,
    BookID		INT NOT NULL,
    ReservedDate   	DATE NOT NULL,
    ReservedStatus 	ENUM('RESERVED', 'CANCELLED', 'COMPLETED') NOT NULL,  # Can be RESERVED, CANCELLED OR COMPLETED

    PRIMARY KEY(UserID, BookID, ReservedDate),
    FOREIGN KEY(UserID) REFERENCES LibraryUser(UserID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(BookID) REFERENCES Book(BookID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Writes;

CREATE TABLE Writes (
    AuthorID	        INT NOT NULL,
    BookID		INT NOT NULL,

    PRIMARY KEY(AuthorID, BookID),
    FOREIGN KEY(AuthorID) REFERENCES Author(AuthorID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(BookID) REFERENCES Book(BookID) ON DELETE CASCADE ON UPDATE CASCADE
);

########## INSERTING DATA ###########

DELETE FROM LibraryUser; #delets pre-existing rows
INSERT INTO LibraryUser (UserID, FirstName, LastName, BirthDate, LoanerNumber, UserStatus) VALUES
(1, 'Sule', 	 'Altintas',      '1995-08-30', '154399', 'ACTIVE'),		
(2, 'Fahad', 	 'Sajad', 	  '1990-05-09', '160344', 'ACTIVE'),		
(3, 'Sebastian', 'Sbirna', 	  '1997-05-04', '190553', 'ACTIVE'),		
(4, 'Kåre',      'Jørgensen',     '1994-05-09', '144852', 'ACTIVE'),		
(5, 'Mary', 	 'Little', 	  '2013-05-07', '100115', 'ACTIVE'),		
(6, 'Humphrey
',  'Oldman', 	  '1942-01-01', '997953', 'TERMINATED'), 	
(7, 'Billy', 	 'Bully', 	  '2007-04-25', '203442', 'BLOCKED'),
(8, 'Sandra', 	 'Quninlan', 	  '1994-08-25', '507482', 'ACTIVE'),
(9, 'Yasmin', 	 'Kristia', 	  '1995-05-29', '535445', 'ACTIVE'),
(10, 'Marianna',  'Mariyam', 	  '1996-04-10', '215456', 'ACTIVE'),
(11, 'Jason',  'Mathilde', 	  '1993-05-12', '124512', 'ACTIVE'),
(12, 'Fareeha',  'Keri', 	  '1992-05-08', '426121', 'BLOCKED'),
(13, 'Ségolène',  'Sébastien', 	  '1992-02-24', '452102', 'ACTIVE'),
(14, 'Elyzabeth',  'Carlyle', 	  '1990-05-12', '165412', 'ACTIVE'),
(15, 'Jason',  'Mathilde', 	  '1993-05-12', '124589', 'ACTIVE'),
(16, 'Landyn',  'Hugo', 	  '1991-02-21', '126561', 'TERMINATED'),
(17, 'Marisol',  'Yasir', 	  '1997-02-19', '455100', 'ACTIVE'),
(18, 'Ricarda',  'Audie', 	  '1991-03-12', '959123', 'ACTIVE'),
(19, 'Fleurette',  'Baudouin', 	  '1990-01-14', '456132', 'ACTIVE'),
(20, 'Finn',  'Anastas', 	  '1993-05-26', '842319', 'ACTIVE'),
(21, 'Shannah',  'Marzell', 	  '1998-03-30', '652213', 'ACTIVE'),
(22, 'Elvis',  'Sabas', 	  '1991-12-18', '233554', 'BLOCKED'),
(23, 'Wolfgang',  'Patricia', 	  '1994-08-01', '165105', 'ACTIVE'),
(24, 'Betony',  'Imran', 	  '1999-08-11', '451355', 'ACTIVE'),
(25, 'Emmy',  'Wren', 	  '1995-06-13', '785415', 'ACTIVE'),
(26, 'Siva',  'Léontine', 	  '1997-02-14', '653358', 'ACTIVE'),
(27, 'Parsifal',  'Candis', 	  '1991-05-16', '124897', 'ACTIVE'),
(28, 'Sergio',  'Dilshad', 	  '2000-05-29', '211228', 'ACTIVE'),
(29, 'Rita',  'Odin', 	  '1997-03-26', '897912', 'ACTIVE'),
(30, 'Drea',  'Savannah', 	  '1998-04-28', '135457', 'TERMINATED'),
(31, 'Karola',  'Miracle', 	  '1995-09-18', '126543', 'ACTIVE'),
(32, 'Dorian',  'Tamika', 	  '1993-09-27', '832328', 'ACTIVE'),
(33, 'Christabelle',  'Philippine',  '1999-03-11', '641212', 'ACTIVE'),
(34, 'Zacarías',  'Chanda', 	  '1998-08-23', '325654', 'ACTIVE'),
(35, 'Kaitlynn',  'Kiaran', 	  '1997-04-12', '651389', 'BLOCKED'),
(36, 'Amanda',  'Corinna', 	  '1994-05-13', '984121', 'ACTIVE'),
(37, 'Journee',  'Jimeno', 	  '1996-02-19', '516215', 'TERMINATED'),
(38, 'Winoc',  'Jia', 	  '1998-01-06', '256413', 'ACTIVE'),
(39, 'Chauncey',  'Vicky', 	  '2000-04-16', '995321', 'ACTIVE'),
(40, 'Dolores',  'Telmo', 	  '2001-10-26', '135601', 'ACTIVE'),
(41, 'Ulli',  'Roni', 	  '1991-01-06', '126559', 'ACTIVE'),
(42, 'Morton',  'Nilda', 	  '1996-08-12', '189512', 'ACTIVE'),
(43, 'Allan',  'Eulogia', 	  '1998-07-02', '564130', 'BLOCKED'),
(44, 'Rachelle',  'Carina', 	  '1996-02-26', '541223', 'ACTIVE'),
(45, 'Aelita',  'Adélard', 	  '1998-02-05', '545112', 'ACTIVE'),
(46, 'Glory',  'Íngrid', 	  '1995-02-28', '451284', 'TERMINATED'),
(47, 'Jade',  'Kaety', 	  '1992-06-18', '451128', 'ACTIVE'),
(48, 'Soraya',  'Milagros', 	  '1998-04-12', '785121', 'ACTIVE'),
(49, 'Sunday',  'Gracia', 	  '2000-06-05', '881457', 'ACTIVE'),
(50, 'Waylon',  'Luke', 	  '1993-04-23', '987234', 'ACTIVE');

DELETE FROM Author;
INSERT INTO Author (AuthorID, FirstName, LastName, Nationality) VALUES
(1, 'Haruki', 'Murakami', 'Japan'),
(2, 'Helle', 'Helle','Denmark'),
(3, 'Ernest', 'Hemingsway', 'USA'),
(4, 'Georges', 'Simenon', 'Belgium'),
(5, 'Martin', 'Simon',  'Denmark'),
(6, 'Avi',	'Silberschatz', 'USA'),
(7, 'Henry', 'Korth', 'USA'),
(8, 'S.', 'Sudarshan',	'USA'),
(9, 'Paul',	'Auster',	'USA'),
(10, 'Martha',	' Kelly',	'United Kingdom'),
(11, 'Deborah', 'Levy', 'Australia'),
(12, 'Valeria', 'Luiselli','France'),
(13, 'Neil', 'Gaiman', 'USA'),
(14, 'Jim', 'Crace', NULL),
(15, 'Ted', 'Chiang',  'China'),
(16, 'Kate',	'Pickett', 'United Kingdom'),
(17, 'Yuri', 'Herrera', 'Israel'),
(18, 'Daniel', 'Kahneman',	'Sweden'),
(19, 'Olga',	'Tokarczuk',	'Norway'),
(20, 'Sebastian',	'Barry',	'USA'),
(21, 'Barbara', 'Demick', 'USA'),
(22, 'Shoshana', 'Zuboff','Jordan'),
(23, 'Chris', 'Ware', 'USA'),
(24, 'Zoë', 'Heller', 'Belgium'),
(25, 'John',	'Carré',	'Canada');

DELETE FROM Genre;
INSERT INTO Genre (GenreID, GenreType, GenreSubtype) VALUES
(1, 'Fiction', 		'Romance'),
(2, 'Fiction', 		'Horror'),
(3, 'Fiction', 		'Thriller'),
(4, 'Fiction', 		'Science Fiction'),
(5, 'Non-fiction', 	'Guide'),
(6, 'Non-fiction', 	'Textbook'),
(7, 'Fiction', 		'Crime'),
(8, 'Fiction', 		'Fantasy'),
(9, 'Non-fiction', 	'Prayer'),
(10, 'Non-fiction', 	'Autobiography'),
(11, 'Non-fiction', 	'Business'),
(12, 'Fiction', 	'Classic'),
(13, 'Non-fiction', 	'History'),
(14, 'Non-fiction', 	'Humor'),
(15, 'Non-fiction', 	'Philosophy'),
(16, 'Non-fiction', 	'Sports'),
(17, 'Fiction', 	'Action'),
(18, 'Fiction', 	'Crime'),
(19, 'Fiction', 	'Poetry'),
(20, 'Non-fiction', 	'Religion');

DELETE FROM Publisher;
INSERT INTO Publisher (PublisherID, PublisherName, HQCountry) VALUES
(1, 'Klim', 'Denmark'),
(2, 'Samleren', 'Denmark'),
(3, 'Lindhardt og Ringhof',	'Denmark'),
(4, 'Gyldendal', NULL),
(5, 'Textmaster', 'USA'),
(6, 'McGraw-Hill',	'USA'),
(7, 'Faber and Faber',	NULL),
(8, 'Penguin', NULL),
(9, 'Bloomsbury', 'United Kingdom'),
(10, 'Pearson',	'United Kingdom'),
(11, 'Oxford', 'United Kingdom'),
(12, 'Hachette', 'USA'),
(13, 'Simon and Schuster',	'USA'),
(14, 'Macmillan', 'USA'),
(15, 'Albert Bonnier', 'Sweden'),
(16, 'Opal',	'Sweden'),
(17, 'Ventura', 'Australia'),
(18, 'Ginninderra', 'Australia'),
(19, 'Wiley', 'USA'),
(20, 'Klett',	'USA');

DELETE FROM Book;
INSERT INTO Book (BookID, Title, ReleaseYear, PageCount, TotalQuantity, TextLanguage, PublisherID, GenreID) VALUES
(1, 'Kafka på stranden', '2007', 505, 5, 'Danish', 1, 4),
(2, '1Q84', '2011', 928, 4, 'Danish', 1,	1),
(3, 'Rødby-Puttgarden', '2011', NULL, 1, 'Danish', 2, 3),
(4, 'Maigret',	'2017', 144, 10, 'Danish', 3,	7),
(5, 'Windows 8.1 - Effektiv uden touch', '2014', 255, 1, 'Danish', 5,	5),
(6, 'Database System Concepts, Sixth Edition',	'2010', 1349,	5, 'English', 6,	6),
(7, 'The New Tork Trilogy', '1985', 478, 2, 'English', 7,	7),
(8, 'Sunflower Sisters', '2013', 613, 8, 'English', 8, 15),
(9, 'Nooit meer slapen', '2006', 749, 2, 'Danish', 3,	NULL),
(10, 'Lost Roses', '2019', NULL, 5, 'English', 8, 3),
(11, 'One Hundred Years of Solitude',	'1997', 444, 6, 'English', 17,	20),
(12, 'In Cold Blood', '2015', 765, 4, 'Swedish', 9,	18),
(13, 'Wide Sargasso Sea',	'2012', 1149,	5, 'Swedish', 20,	17),
(14, 'Brave New World', '1963', 408, 4, 'English', 18,	14),
(15, 'I Capture The Castle', '2001', 652, 3, 'English', 1, 10),
(16, 'Jane Eyre', '2017', 641, 4, 'Swedish', 1,	12),
(17, 'Crime and Punishment', '2013', NULL, 1, 'Danish', 19, 13),
(18, 'The Secret History',	'1992', 512, 10, 'English', 8,	7),
(19, 'The Call of the Wild', '2015', 315, 6, 'English', 17,	15),
(20, 'The Chrysalids',	'1995', 1206,	1, 'Swedish', 10,	16),
(21, 'Persuasion', '2014', 489, 3, 'English', 11,	14),
(22, ' Moby-Pick', '2017', 509, 2, 'Danish', 3, 9),
(23, 'The Lion, the Witch and the Wardrobe', '2001', 628, 4, 'English', 5,	1),
(24, 'To the Lighthouse', NULL, NULL, 1, 'English', 12, 7),
(25, 'The Death of the Heart',	'1997', 344, 7, 'English', 8,	6),
(26, 'Tess of the d Urbervilles', '2006', 295, 1, 'Danish', 6,	15),
(27, 'Frankenstein',	'2010', 649,	5, 'English', 14,	10),
(28, 'The Master and Margarita', '2017', NULL, 2, 'Swedish', 7,	12),
(29, 'Go-Between', '2017', 360, 3, 'Danish', 11, 4),
(30, 'Beloved', '2011', 928, 4, 'Swedish', 13,	11),
(31, 'Buddenbrooks', '2009', NULL, 4, 'Danish', 2, 6),
(32, 'The Code of the Woosters', '1992', 304, 7, 'English', 3,	8),
(33, 'Dracula', '2004', 155, 6, 'English', 6,	4),
(34, 'Great Expectations',	'2010', 449,	5, 'English', 16,	4),
(35, 'Catch-22', '1986', 810, 2, 'English', 3,	14),
(36, 'A Little Life', '2015', 305, 5, 'English', 2, 7),
(37, 'The Tipping Point', '2001', 418, 4, 'English', 3,	5),
(38, 'Visitatien', '2010', NULL, 1, 'Danish', 16, 9),
(39, 'Noughts & Crosses',	'2017', 144, 10, 'English', 13,	3),
(40, 'The Cost of Living', NULL, 255, 8, 'English', 14,	11);

DELETE FROM Fine; 
INSERT INTO Fine (FineID, Amount, UserID, IssuedDate, PaymentStatus) VALUES
(1, 100.00, 7, '2020-09-17', 'NOT PAID'),
(2, 50.00, 7, '2019-12-20', 'NOT PAID'),
(3, 100.00, 8, '2019-12-14', 'NOT PAID'),
(4, 50.00, 23, '2020-11-19', 'NOT PAID'),
(5, 100.00, 49, '2021-01-15', 'NOT PAID'),
(6, 150.00, 5, '2020-12-19', 'NOT PAID'),
(7, 100.00, 18, '2021-02-23', 'NOT PAID'),
(8, 100.00, 5, '2020-12-31', 'NOT PAID'),
(9, 100.00, 35, '2021-03-19', 'NOT PAID'),
(10, 100.00, 28, '2020-10-12', 'PAID'),
(11, 150.00, 8, '2019-12-29', 'NOT PAID'),
(12, 100.00, 18, '2020-09-14', 'NOT PAID'),
(13, 100.00, 6, '2021-01-15', 'NOT PAID'),
(14, 150.00, 41, '2019-08-12', 'NOT PAID'),
(15, 100.00, 35, '2020-06-25', 'NOT PAID'),
(16, 50.00, 6, '2021-02-11', 'NOT PAID'),
(17, 100.00, 18, '2020-04-24', 'NOT PAID'),
(18, 100.00, 18, '2020-12-26', 'NOT PAID'),
(19, 150.00, 33, '2021-03-01', 'NOT PAID'),
(20, 50.00, 22, '2020-12-03', 'PAID');

DELETE from Loans;
INSERT Loans (UserID, BookID, LoanedDate, UntilDate, ReturnedDate, LoanedStatus) VALUES
(5, 4, '2019-01-05', TIMESTAMPADD(DAY, 30, '2019-01-05'), '2019-01-24', 	'RETURNED'),
(5, 3, '2019-01-17', TIMESTAMPADD(DAY, 30, '2019-01-17'), '2019-02-13', 	'RETURNED'),
(7, 4, '2019-08-17', TIMESTAMPADD(DAY, 30, '2019-08-17'),	  NULL,		'FINED'),
(7, 9, '2019-09-20', TIMESTAMPADD(DAY, 30, '2019-09-20'),	  NULL,		'FINED'),
(8, 14, '2019-12-14',TIMESTAMPADD(DAY, 30, '2019-12-14'), NULL,	'FINED'),
(23, 6, '2020-11-19',TIMESTAMPADD(DAY, 30, '2020-11-19'), NULL,	'FINED'),
(49,7, '2021-01-15',TIMESTAMPADD(DAY, 30, '2021-01-15'), NULL,	'FINED'),
(5, 36, '2020-12-19',TIMESTAMPADD(DAY, 30, '2020-12-19'),NULL,   'FINED'),
(18, 9, '2021-02-23',TIMESTAMPADD(DAY, 30, '2021-02-23'), NULL, 'FINED'),
(5, 1, '2020-12-31',TIMESTAMPADD(DAY, 30, '2020-12-31'), NULL,	'FINED'),
(35, 31, '2021-03-19',TIMESTAMPADD(DAY, 30, '2021-03-19'), NULL, 'FINED'),
(28, 31, '2020-10-12',TIMESTAMPADD(DAY, 30, '2020-10-12'), NULL, 'FINED'),
(8, 18, '2019-12-29',TIMESTAMPADD(DAY, 30, '2019-12-29'), NULL, 'FINED'),
(18, 18, '2020-09-14',TIMESTAMPADD(DAY, 30, '2020-09-14'), NULL, 'FINED'),
(6, 32, '2021-01-15',TIMESTAMPADD(DAY, 30, '2021-01-15'), NULL,	'FINED'),
(41, 28, '2019-08-12',TIMESTAMPADD(DAY, 30, '2019-08-12'), NULL,	'FINED'),
(35, 21, '2020-06-25',TIMESTAMPADD(DAY, 30, '2020-06-25'), NULL,	'FINED'),
(6, 11, '2021-02-11',TIMESTAMPADD(DAY, 30, '2021-02-11'), NULL, 'FINED'),
(18, 40, '2020-04-24',TIMESTAMPADD(DAY, 30, '2020-04-24'), NULL, 'FINED'),
(18, 34, '2020-12-26',TIMESTAMPADD(DAY, 30, '2020-12-26'), NULL, 'FINED'),
(33, 11,'2021-03-01',TIMESTAMPADD(DAY, 30, '2021-03-01'), NULL, 'FINED'),
(22, 8, '2020-12-03',TIMESTAMPADD(DAY, 30, '2020-12-03'), NULL, 'FINED'),
(30, 28, '2020-10-17',	TIMESTAMPADD(DAY, 30, '2020-10-17'),	'2020-11-21', 'RETURNED'),
(42, 12, '2020-10-14', TIMESTAMPADD(DAY, 30, '2020-10-14'),	'2020-11-18', 'RETURNED'),
(24, 29, '2020-01-28', TIMESTAMPADD(DAY, 30, '2020-01-28'),	'2020-03-03',	'RETURNED'),
(43, 19, '2021-03-07', TIMESTAMPADD(DAY, 30, '2021-03-07'), '2021-04-11',	'RETURNED'),
(22, 23, '2020-03-26', TIMESTAMPADD(DAY, 30, '2020-03-26'),	'2020-04-30',	'RETURNED'),
(31, 4, '2019-05-04', TIMESTAMPADD(DAY, 30, '2019-05-04'),	'2019-06-08', 	'RETURNED'),
(36, 32, '2020-06-27',	TIMESTAMPADD(DAY, 30, '2020-06-27'), '2020-08-01',	'RETURNED'),
(30, 23, '2019-01-29' ,	TIMESTAMPADD(DAY, 30, '2019-01-29'), '2019-03-05' ,	'RETURNED'),
(18, 39, '2019-11-08' ,	TIMESTAMPADD(DAY, 30, '2019-11-08'), '2019-12-13', 'RETURNED'),
(31, 10, '2020-12-26', TIMESTAMPADD(DAY, 30, '2020-12-26'),	'2021-01-30', 'RETURNED'),
(22, 37, '2020-01-01',	TIMESTAMPADD(DAY, 30, '2020-01-01'), '2020-02-05','RETURNED'),
(21, 36, '2019-01-20',	TIMESTAMPADD(DAY, 30, '2019-01-20'), '2019-02-24', 'RETURNED'),
(5, 28, '2019-04-06', TIMESTAMPADD(DAY, 30, '2019-04-06'),	'2019-05-11',	'RETURNED'),
(20, 10, '2019-06-29',	TIMESTAMPADD(DAY, 30, '2019-06-29'), '2019-08-03',	'RETURNED'),
(6, 12, '2020-01-28',	TIMESTAMPADD(DAY, 30, '2020-01-28'), '2020-03-03', 	'RETURNED'),
(3, 32, '2020-02-07', TIMESTAMPADD(DAY, 30, '2020-02-07'),	'2020-03-13', 	'RETURNED'),
(40, 14, '2020-04-12',	TIMESTAMPADD(DAY, 30, '2020-04-12'), '2020-05-17',	'RETURNED'),
(47, 39, '2020-06-05',	TIMESTAMPADD(DAY, 30, '2020-06-05'),'2020-07-10',	'RETURNED'),
(39, 14, '2020-06-23',	TIMESTAMPADD(DAY, 30, '2020-06-23'), '2020-07-28',	'RETURNED'),
(43, 6, '2019-07-02' , TIMESTAMPADD(DAY, 30, '2019-07-02'),	'2019-08-06',	'RETURNED'),
(37, 1,  '2019-10-14',	TIMESTAMPADD(DAY, 30, '2019-10-14'),	NULL,	'LOANED'),
(14, 39, '2020-03-25',	TIMESTAMPADD(DAY, 30, '2020-03-25'), NULL,		'LOANED'),
(14, 22, '2020-02-07',	TIMESTAMPADD(DAY, 30, '2020-02-07'), NULL,		'LOANED'),
(21, 6, '2019-10-06',	TIMESTAMPADD(DAY, 30, '2019-10-06'), NULL,		'LOANED'),
(45, 27, '2020-07-12',	TIMESTAMPADD(DAY, 30, '2020-07-12'), NULL,		'LOANED'),
(15, 30, '2021-02-10',	TIMESTAMPADD(DAY, 30, '2021-02-10'), NULL,		'LOANED'),
(7, 7, '2019-09-15', TIMESTAMPADD(DAY, 30, '2019-09-15'), NULL, 		'LOANED'),
(29, 15, '2019-07-07', TIMESTAMPADD(DAY, 30, '2019-07-07'), NULL, 		'LOANED'),
(3, 28, '2019-06-19', TIMESTAMPADD(DAY, 30, '2019-06-19'), NULL, 		'LOANED'),
(10, 38, '2019-11-27', TIMESTAMPADD(DAY, 30, '2019-11-27'), NULL,		'LOANED'),
(9, 13, '2019-04-01', TIMESTAMPADD(DAY, 30, '2019-04-01'), NULL, 		'LOANED'),
(21, 29, '2020-10-25', TIMESTAMPADD(DAY, 30, '2020-10-25'), NULL,    	'LOANED'),
(40, 15, '2019-01-21',	TIMESTAMPADD(DAY, 30, '2019-01-21'), NULL,		'LOANED'),
(46, 27, '2019-05-23',	TIMESTAMPADD(DAY, 30, '2019-05-23'), NULL,		'LOANED'),
(37, 27, '2020-07-09', TIMESTAMPADD(DAY, 30, '2020-07-09'), NULL,		'LOANED'),
(21, 10, '2019-05-13',	TIMESTAMPADD(DAY, 30, '2019-05-13'), NULL,		'LOANED'),
(4, 4, '2019-11-21', TIMESTAMPADD(DAY, 30, '2019-11-21'), NULL,		    'LOANED'),
(17, 12, '2020-04-22',	TIMESTAMPADD(DAY, 30, '2020-04-22'), NULL,   	'LOANED'),
(36, 37, '2020-01-25', TIMESTAMPADD(DAY, 30, '2020-01-25'), NULL,		'LOANED'),
(43, 34, '2019-02-26', TIMESTAMPADD(DAY, 30, '2019-02-26'), NULL,		'LOANED'),
(37, 37, '2020-09-10',	TIMESTAMPADD(DAY, 30, '2020-09-10'), NULL,		'LOANED'),
(40, 14, '2019-12-28',	TIMESTAMPADD(DAY, 30, '2019-12-28'), NULL,		'LOANED'),
(22, 10, '2019-08-29', TIMESTAMPADD(DAY, 30, '2019-08-29'), NULL, 		'LOANED'),
(8, 11, '2019-06-08', TIMESTAMPADD(DAY, 30, '2019-06-08'), NULL,		'LOANED'),
(25, 11, '2020-08-16', TIMESTAMPADD(DAY, 30, '2020-08-16'), NULL, 		'LOANED'),
(24, 37, '2020-02-09',	TIMESTAMPADD(DAY, 30, '2020-02-09'), NULL, 		'LOANED'),
(19, 22, '2020-07-31',	TIMESTAMPADD(DAY, 30, '2020-07-31'), NULL,		'LOANED'),
(45, 30, '2019-08-18', TIMESTAMPADD(DAY, 30, '2019-08-18'), NULL,		'LOANED'),
(33, 34, '2019-04-18', TIMESTAMPADD(DAY, 30, '2019-04-18'), NULL,		'LOANED'),
(13, 35, '2020-06-11',	TIMESTAMPADD(DAY, 30, '2020-06-11'), NULL,		'LOANED'),
(31, 19, '2020-03-02', TIMESTAMPADD(DAY, 30, '2020-03-02'), NULL,		'LOANED'),
(38, 34, '2020-03-31', TIMESTAMPADD(DAY, 30, '2020-03-31'), NULL,		'LOANED'),
(19, 30, '2019-02-23', TIMESTAMPADD(DAY, 30, '2019-02-23'), NULL,		'LOANED'),
(2, 16, '2019-03-27', TIMESTAMPADD(DAY, 30,	'2019-03-27'), NULL,  		'LOANED'),
(48, 24, '2019-10-17',	TIMESTAMPADD(DAY, 30, '2019-10-17'), NULL,		'LOANED'),
(48, 6,  '2019-09-26',	TIMESTAMPADD(DAY, 30, '2019-09-26'), NULL,		'LOANED'),
(47, 32, '2020-03-21',	TIMESTAMPADD(DAY, 30, '2020-03-21'), NULL,		'LOANED'),
(23, 23, '2019-09-28', TIMESTAMPADD(DAY, 30, '2019-09-28'), NULL,		'LOANED'),
(9, 21, '2019-10-12',	TIMESTAMPADD(DAY, 30, '2019-10-12'), NULL,		'LOANED'),
(9, 15, '2019-03-01', TIMESTAMPADD(DAY, 30,	'2019-03-01'), NULL, 		'LOANED'),
(12, 14, '2019-10-08', TIMESTAMPADD(DAY, 30, '2019-10-08'), NULL,		'LOANED'),
(45, 30, '2019-02-15',	TIMESTAMPADD(DAY, 30, '2019-02-15'), NULL, 		'LOANED'),
(6, 29, '2020-10-24', TIMESTAMPADD(DAY, 30,	'2020-10-24'), NULL,		'LOANED'),
(44, 6, '2020-07-06',	TIMESTAMPADD(DAY, 30, '2020-07-06'), NULL,		'LOANED'),
(27, 11, '2021-02-01', TIMESTAMPADD(DAY, 30, '2021-02-01'), NULL,		'LOANED'),
(32, 12, '2019-11-29',	TIMESTAMPADD(DAY, 30, '2019-11-29'), NULL,		'LOANED'),
(4, 31, '2019-10-04', TIMESTAMPADD(DAY, 30,	'2019-10-04'), NULL,		'LOANED'),
(35, 1, '2020-01-09', TIMESTAMPADD(DAY, 30,	'2020-01-09'),	NULL,	    'LOANED'),
(22, 34, '2019-10-16', TIMESTAMPADD(DAY, 30, '2019-10-16'), NULL,		'LOANED'),
(19, 18, '2021-01-25',	TIMESTAMPADD(DAY, 30, '2021-01-25'), NULL,		'LOANED'),
(13, 36, '2019-12-23', TIMESTAMPADD(DAY, 30, '2019-12-23'),	NULL, 	    'LOANED'),
(50, 9, '2019-11-12', TIMESTAMPADD(DAY, 30,	'2019-11-12'), NULL,		'LOANED'),
(3, 6, '2019-09-23', TIMESTAMPADD(DAY, 30, '2019-09-23'), NULL, 		'LOANED'),
(40, 35, '2020-10-04', TIMESTAMPADD(DAY, 30, '2020-10-04'), NULL,		'LOANED'),
(17, 20, '2019-07-16', TIMESTAMPADD(DAY, 30, '2019-07-16'), NULL,		'LOANED'),
(27, 15, '2019-03-11',	TIMESTAMPADD(DAY, 30, '2019-03-11'), NULL,		'LOANED'),
(10, 29, '2020-09-24', TIMESTAMPADD(DAY, 30, '2020-09-24'), NULL,		'LOANED'),
(17, 10, '2020-01-07', TIMESTAMPADD(DAY, 30, '2020-01-07'), NULL,		'LOANED');

DELETE FROM Reserves; 
INSERT Reserves (UserID, BookID, ReservedDate, ReservedStatus) VALUES
(2, 5, '2021-05-10', 'RESERVED'),
(4, 15, '2021-06-01', 'RESERVED'),
(8, 18, '2021-07-23', 'CANCELLED'),
(15, 26, '2021-05-01', 'COMPLETED'),
(26, 17, '2021-05-12', 'RESERVED'),
(31, 29, '2021-04-10', 'COMPLETED'),
(12, 8, '2021-05-21', 'RESERVED'),
(36, 30, '2021-03-10', 'CANCELLED'),
(14, 22, '2021-05-06', 'RESERVED'),
(45, 19, '2021-03-10', 'COMPLETED'),
(9, 33, '2021-04-30', 'RESERVED'),
(5, 16, '2021-05-16', 'RESERVED'),
(37, 26, '2021-06-11', 'RESERVED'),
(41, 40, '2021-05-19', 'RESERVED'),
(35, 25, '2021-07-01', 'RESERVED'),
(21, 32, '2021-06-06', 'CANCELLED'),
(18, 7, '2021-04-04', 'COMPLETED'),
(4,30,'2021-07-24','CANCELLED'),
(45,5,'2021-07-22','CANCELLED'),
(36,7,'2021-06-20','RESERVED'),
(9,23,'2021-05-26','RESERVED'),
(47,16,'2021-07-07','RESERVED'),
(24,25,'2021-07-23','CANCELLED'),
(25,11,'2021-05-04','RESERVED'),
(38,25,'2021-05-10','RESERVED'),
(10,35,'2021-05-09','RESERVED'),
(31,16,'2021-06-10','RESERVED'),
(7,39,'2021-07-12','RESERVED'),
(10,30,'2021-06-16','RESERVED'),
(15,37,'2021-07-24','CANCELLED'),
(9,18,'2021-07-04','RESERVED'),
(32,40,'2021-05-04','RESERVED'),
(7,4,'2021-07-31','CANCELLED'),
(28,13,'2021-05-21','RESERVED'),
(7,31,'2021-04-22','COMPLETED'),
(34,40,'2021-05-02','RESERVED'),
(13,4,'2021-06-16','RESERVED'),
(50,4,'2021-05-21','RESERVED'),
(25,27,'2021-06-29','RESERVED'),
(44,24,'2021-07-22','CANCELLED'),
(3,22,'2021-07-16','CANCELLED'),
(47,9,'2021-06-10','RESERVED'),
(49,40,'2021-06-19','RESERVED'),
(48,26,'2021-06-29','RESERVED'),
(5,18,'2021-04-01','COMPLETED'),
(11,14,'2021-05-04','RESERVED'),
(33,35,'2021-05-07','RESERVED'),
(5,19,'2021-07-23','CANCELLED'),
(2,7,'2021-07-06','RESERVED'),
(48,22,'2021-06-12','RESERVED'),
(34,26,'2021-04-11','COMPLETED'),
(21,14,'2021-06-06','RESERVED'),
(33,17,'2021-06-14','RESERVED'),
(50,12,'2021-05-29','RESERVED'),
(36,10,'2021-05-26','RESERVED'),
(31,36,'2021-05-13','RESERVED'),
(25,34,'2021-05-14','RESERVED'),
(38,17,'2021-05-27','RESERVED'),
(4,21,'2021-05-16','RESERVED'),
(6,14,'2021-06-04','CANCELLED'),
(40,37,'2021-04-01','COMPLETED'),
(31,4,'2021-07-30','RESERVED'),
(16,35,'2021-06-13','CANCELLED'),
(30,24,'2021-06-12','RESERVED'),
(20,31,'2021-04-25','COMPLETED'),
(14,23,'2021-06-09','RESERVED'),
(48,5,'2021-07-29','RESERVED'),
(50,19,'2021-05-25','RESERVED'),
(2,28,'2021-06-18','RESERVED'),
(12,3,'2021-04-21','COMPLETED'),
(1,40,'2021-07-25','CANCELLED'),
(22,36,'2021-06-15','CANCELLED'),
(26,28,'2021-07-20','RESERVED'),
(24,19,'2021-04-12','COMPLETED'),
(26,30,'2021-06-14','CANCELLED'),
(14,1,'2021-04-10','COMPLETED'),
(5,7,'2021-06-28','CANCELLED'),
(20,8,'2021-07-01','RESERVED'),
(15,15,'2021-05-18','RESERVED'),
(37,21,'2021-06-20','RESERVED'),
(3,4,'2021-06-08','RESERVED'),
(14,10,'2021-06-09','CANCELLED'),
(13,20,'2021-06-12','RESERVED'),
(2,24,'2021-05-26','RESERVED'),
(3,33,'2021-06-17','CANCELLED'),
(2,2,'2021-04-09','COMPLETED'),
(38,40,'2021-06-10','CANCELLED'),
(38,24,'2021-06-22','CANCELLED'),
(29,32,'2021-04-02','COMPLETED'),
(50,33,'2021-04-18','COMPLETED'),
(30,15,'2021-05-09','CANCELLED'),
(14,34,'2021-06-08','RESERVED'),
(27,22,'2021-07-03','CANCELLED'),
(13,23,'2021-07-26','RESERVED'),
(43,13,'2021-07-02','CANCELLED'),
(18,23,'2021-05-04','RESERVED'),
(20,33,'2021-06-16','RESERVED'),
(47,31,'2021-05-27','RESERVED'),
(20,36,'2021-05-20','CANCELLED'),
(41,25,'2021-07-02','RESERVED');

DELETE FROM Writes; 
INSERT Writes (AuthorID, BookID) VALUES
(1, 1),
(1, 2),
(2, 3),
(4, 4),
(5, 5),
(6, 8),
(7, 6),
(8, 6),
(9, 7),
(15,21),
(23,4),
(10,33),
(10,38),
(22,20),
(17,32),
(24,39),
(18,15),
(11,10),
(13,30),
(25,10),
(7,38),
(15,12),
(10,17),
(13,9),
(8,1),
(4,30),
(1,10),
(3,24),
(7,4),
(13,37),
(19,11),
(15,16),
(5,37),
(13,25),
(21,15),
(7,23),
(21,5),
(17,39),
(12,27),
(9,5),
(13,38),
(14,8),
(16,32),
(23,23),
(20,29),
(7,39),
(3,18),
(12,32),
(22,30),
(17,10),
(9,24),
(5,14),
(20,35),
(15,2),
(8,2),
(20,14),
(4,1),
(8,27),
(20,32),
(25,36),
(19,2),
(25,21),
(5,22),
(25,40),
(16,6),
(7,40),
(6,39),
(7,27),
(6,6),
(2,24),
(15,20),
(17,29),
(24,30),
(1,24),
(5,7),
(6,1),
(20,20),
(18,26),
(9,16),
(20,16),
(13,10),
(14,7),
(3,36),
(21,17),
(20,6),
(3,7),
(19,18),
(20,9),
(25,33),
(17,40),
(21,3),
(21,7),
(5,9),
(25,38),
(19,33),
(1,19),
(5,2),
(17,7),
(18,4),
(11,8);

SELECT * FROM LibraryUser;
SELECT * FROM Author;
SELECT * FROM Genre;
SELECT * FROM Publisher;
SELECT * FROM Book;
SELECT * FROM Fine;

SELECT * FROM Loans;
SELECT * FROM Reserves;
SELECT * FROM Writes;

####################################################################################
############################## BASIC SQL PROGRAMMING ###############################
####################################################################################

###############################################################################
############################## SQL DATA QUERY 1 ###############################
###############################################################################

# This query shows all books and their authors.

SELECT GROUP_CONCAT(Author.AuthorID SEPARATOR ', ') AS AuthorIds,
       GROUP_CONCAT(CONCAT(Author.FirstName,' ', Author.LastName) SEPARATOR ', ') AS AuthorNames,
       Writes.BookID,
       Book.Title BookTitle
FROM Writes
JOIN Author on Writes.AuthorID = Author.AuthorID
JOIN Book on Writes.BookID = Book.BookID
GROUP BY Writes.BookID;

###############################################################################
############################## SQL DATA QUERY 2 ###############################
###############################################################################

# This query shows the number of books the Library has from each author. Shows the author with the most books first, and so on.

SELECT   Author.AuthorID,
         CONCAT(Author.FirstName,' ', Author.LastName) AS FullName,
         COUNT(*) AS NumberOfBooks
FROM     Author
JOIN     Writes ON Author.AuthorID = Writes.AuthorID
GROUP BY FullName
ORDER BY NumberOfBooks DESC;

###############################################################################
############################## SQL DATA QUERY 3 ###############################
###############################################################################

# This query gives an overview of all loans for each library user and the status of these.

SELECT LibraryUser.UserID,
		CONCAT(LibraryUser.FirstName,' ', LibraryUser.LastName) AS FullName,
       SUM(LoanedStatus LIKE 'LOANED') AS ActiveLoans,
       SUM(LoanedStatus LIKE 'RETURNED') AS Returned,
       SUM(LoanedStatus LIKE 'FINED') AS Fined,
       COUNT(*) AS Total
FROM LibraryUser
JOIN Loans on LibraryUser.UserID = Loans.UserID
GROUP BY UserID;

###############################################################################
############################## SQL DATA QUERY 4 ###############################
###############################################################################

#Users who are active and haven't reserved any book

SELECT * FROM LibraryUser
WHERE UserID NOT IN
(SELECT UserID FROM Reserves) AND UserStatus = "ACTIVE";

###############################################################################
############################## SQL DATA QUERY 5 ###############################
###############################################################################

# Periodically library wants to delete the reservation records which are completed
 
DELETE FROM Reserves WHERE ReservedStatus = 'COMPLETED';


#######################################################################################
############################## ADVANCED SQL PROGRAMMING ###############################
#######################################################################################

#######################################################################
############################## FUNCTION 1 #############################
#######################################################################

DROP FUNCTION IF EXISTS LoanedQuantity;

DELIMITER //
CREATE FUNCTION LoanedQuantity(vBookID INT) RETURNS INT
BEGIN
    DECLARE LoanedQuantity INT DEFAULT 0;
    SELECT COUNT(*) INTO LoanedQuantity FROM Loans L
    WHERE L.BookID = vBookID AND L.LoanedStatus != 'RETURNED' GROUP BY BookID;
    RETURN LoanedQuantity;
END //
DELIMITER ;

# Testing the function:

SELECT Title, TotalQuantity, LoanedQuantity(BookID) AS LoanedQuantity, TotalQuantity - LoanedQuantity(BookID) AS OnShelfQuantity
FROM Book;


########################################################################
############################## FUNCTION 2 ##############################
########################################################################

DROP PROCEDURE IF EXISTS LoanBook;

DELIMITER //
CREATE PROCEDURE LoanBook(IN vUserID INT, IN vBookID INT)
BEGIN
    INSERT Loans(UserID, BookID, LoanedDate, UntilDate, ReturnedDate, LoanedStatus)
        VALUES (vUserID, vBookID, NOW(), ADDDATE(CURDATE(), INTERVAL 30 DAY), NULL, 'LOANED');
END //
DELIMITER ;

# Testing the procedure:

# BEFORE:
SELECT B.Title, L.LoanedDate, L.UntilDate, L.LoanedStatus
FROM Book B
NATURAL JOIN Loans L
WHERE L.UserID = 4;

# CALLING THE PROCEDURE:
CALL LoanBook(4, 1);

# AFTER:
SELECT B.Title, L.LoanedDate, L.UntilDate, L.LoanedStatus
FROM Book B
NATURAL JOIN Loans L
WHERE L.UserID = 4;

#########################################################################################
############################## FUNCTION 3 ###############################################
#########################################################################################

DROP PROCEDURE IF EXISTS CreateFines;

DELIMITER //
CREATE PROCEDURE CreateFines()
BEGIN
    START TRANSACTION;
        INSERT INTO Fine (UserID, Amount, IssuedDate, PaymentStatus)
            SELECT UserID, 100.00, CURDATE(), 'NOT PAID' FROM Loans L
            WHERE L.LoanedStatus = 'LOANED' AND DATEDIFF(L.UntilDate, CURDATE()) < 0;

        UPDATE Loans L SET LoanedStatus = 'FINED'
        WHERE L.LoanedStatus = 'LOANED' AND DATEDIFF(L.UntilDate, CURDATE()) < 0;
    COMMIT;
END; //
DELIMITER ;

# Testing the procedure with transaction:

# BEFORE:
SELECT B.BookID, B.Title, L.LoanedDate, L.UntilDate, L.LoanedStatus
FROM Book B
NATURAL JOIN Loans L
WHERE L.UserID = 7;

SELECT * FROM Fine F
WHERE F.UserID = 7;

# CREATE TEST CONDITIONS:
UPDATE Loans L SET L.LoanedDate = ADDDATE(CURDATE(), -40)
WHERE L.UserID = 7 AND L.BookID = 7;

UPDATE Loans L SET L.UntilDate = ADDDATE(CURDATE(), -10)
WHERE L.UserID = 7 AND L.BookID = 7;

# CALLING THE PROCEDURE:
CALL CreateFines();

# AFTER:
SELECT B.Title, L.LoanedDate, L.UntilDate, L.LoanedStatus
FROM Book B
NATURAL JOIN Loans L
WHERE L.UserID = 7;

SELECT * FROM Fine F
WHERE F.UserID = 7;

#################################################################################
############################## DATABASE UPDATE QUERY ############################
#################################################################################

# The library decides to buy more copies of a book that's seeing particularly high demand among library users

SET SQL_SAFE_UPDATES = 0;

# BEFORE:
SELECT * FROM Book;

UPDATE Book SET TotalQuantity = 10
WHERE Title = 'Database System Concepts, Sixth Edition';

# AFTER:
SELECT * FROM Book;

#################################################################################
############################## DATABASE DELETE QUERY ############################ 
#################################################################################

# Say a library user wants to be deleted from the database, 
# and because of GDPR, the library obliges to do so, 
# as long as the user doesn't have any unpaid fines

# This user does not have any active fines, therefore it will be deleted
DELETE FROM LibraryUser
WHERE LoanerNumber = '154399'
AND NOT EXISTS
(SELECT * FROM (SELECT FineID
FROM Fine LEFT JOIN LibraryUser
ON LibraryUser.UserID = Fine.UserID
WHERE LoanerNumber = '154399' AND PaymentStatus = 'NOT PAID') tblTmp);


# This user has outstanding fines, therefore it will not be removed from the database
DELETE FROM LibraryUser
WHERE LoanerNumber = '507482'
AND NOT EXISTS
(SELECT * FROM (SELECT FineID
FROM Fine LEFT JOIN LibraryUser
ON LibraryUser.UserID = Fine.UserID
WHERE LoanerNumber = '507482' AND PaymentStatus = 'NOT PAID') tblTmp);
