/*

Sakila for Oracle is a port of the Sakila example database available for MySQL, which was originally developed by Mike Hillyer of the MySQL AB documentation team. 
This project is designed to help database administrators to decide which database to use for development of new products
The user can run the same SQL against different kind of databases and compare the performance

License: BSD
Copyright DB Software Laboratory
http:www.etl-tools.com

*/


--
-- Table structure for table actor
--
--DROP TABLE actor;

CREATE TABLE actor (
  actor_id numeric NOT NULL ,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_actor PRIMARY KEY  (actor_id)
);

CREATE  INDEX idx_actor_last_name ON actor(last_name);

 
  --DROP SEQUENCE actor_sequence;

CREATE SEQUENCE actor_sequence;

--
-- Table structure for table country
--

CREATE TABLE country (
  country_id SMALLINT NOT NULL,
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP,
  CONSTRAINT pk_country PRIMARY KEY (country_id)
);

---DROP SEQUENCE country_sequence;

CREATE SEQUENCE country_sequence;







--
-- Table structure for table city
--

CREATE TABLE city (
  city_id int NOT NULL,
  city VARCHAR(50) NOT NULL,
  country_id SMALLINT NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_city PRIMARY KEY (city_id),
  CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES country (country_id)
);

CREATE  INDEX idx_fk_country_id ON city(country_id);


--- DROP SEQUENCE city_sequence;

CREATE SEQUENCE city_sequence;



--
-- Table structure for table address
--

CREATE TABLE address (
  address_id int NOT NULL,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id INT  NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_address PRIMARY KEY (address_id)
);

CREATE  INDEX idx_fk_city_id ON address(city_id);


ALTER TABLE address ADD  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id);


  --DROP SEQUENCE city_sequence;

CREATE SEQUENCE address_sequence;




--
-- Table structure for table language
--

CREATE TABLE language (
  language_id SMALLINT NOT NULL ,
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_language PRIMARY KEY (language_id)
);

---DROP SEQUENCE language_sequence;

CREATE SEQUENCE language_sequence;



--
-- Table structure for table category
--

CREATE TABLE category (
  category_id SMALLINT NOT NULL,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_category PRIMARY KEY  (category_id)
);

---DROP SEQUENCE category_sequence;

CREATE SEQUENCE category_sequence;



--
-- Table structure for table customer
--

CREATE TABLE customer (
  customer_id INT NOT NULL,
  store_id INT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id INT NOT NULL,
  active CHAR(1) DEFAULT 'Y' NOT NULL,
  create_date TIMESTAMP NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_customer PRIMARY KEY  (customer_id),
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE  INDEX idx_customer_fk_store_id ON customer(store_id);

CREATE  INDEX idx_customer_fk_address_id ON customer(address_id);

CREATE  INDEX idx_customer_last_name ON customer(last_name);

---DROP SEQUENCE customer_sequence;

CREATE SEQUENCE customer_sequence;



--
-- Table structure for table film
--

CREATE TABLE film (
  film_id int NOT NULL,
  title VARCHAR(255) NOT NULL,
  description CLOB DEFAULT NULL,
  release_year VARCHAR(4) DEFAULT NULL,
  language_id SMALLINT NOT NULL,
  original_language_id SMALLINT DEFAULT NULL,
  rental_duration SMALLINT  DEFAULT 3 NOT NULL,
  rental_rate DECIMAL(4,2) DEFAULT 4.99 NOT NULL,
  length SMALLINT DEFAULT NULL,
  replacement_cost DECIMAL(5,2) DEFAULT 19.99 NOT NULL,
  rating VARCHAR(10) DEFAULT 'G',
  special_features VARCHAR(100) DEFAULT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_film PRIMARY KEY  (film_id),
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ,
  CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id)
);

ALTER TABLE film ADD CONSTRAINT CHECK_special_features CHECK(special_features is null or
                                                              special_features like '%Trailers%' or
                                                              special_features like '%Commentaries%' or
                                                              special_features like '%Deleted Scenes%' or
                                                              special_features like '%Behind the Scenes%');

ALTER TABLE film ADD CONSTRAINT CHECK_special_rating CHECK(rating in ('G','PG','PG-13','R','NC-17'));

CREATE  INDEX idx_fk_language_id ON film(language_id);

CREATE  INDEX idx_fk_original_language_id ON film(original_language_id);


---DROP SEQUENCE film_sequence;

CREATE SEQUENCE film_sequence;




--
-- Table structure for table film_actor
--

CREATE TABLE film_actor (
  actor_id INT NOT NULL,
  film_id  INT NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_film_actor PRIMARY KEY  (actor_id,film_id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id),
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id)
);

CREATE  INDEX idx_fk_film_actor_film ON film_actor(film_id);


CREATE  INDEX idx_fk_film_actor_actor ON film_actor(actor_id) ;




--
-- Table structure for table film_category
--

CREATE TABLE film_category (
  film_id INT NOT NULL,
  category_id SMALLINT  NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_film_category PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id),
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id)
);

CREATE  INDEX idx_fk_film_category_film ON film_category(film_id);

CREATE  INDEX idx_fk_film_category_category ON film_category(category_id);


--
-- Table structure for table film_text
--

CREATE TABLE film_text (
  film_id SMALLINT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description CLOB,
  CONSTRAINT pk_film_text PRIMARY KEY  (film_id)
);

--
-- Table structure for table inventory
--

CREATE TABLE inventory (
  inventory_id INT NOT NULL,
  film_id INT NOT NULL,
  store_id INT NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_inventory PRIMARY KEY  (inventory_id),
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id)
);

CREATE  INDEX idx_fk_film_id ON inventory(film_id);


CREATE  INDEX idx_fk_film_id_store_id ON inventory(store_id,film_id);


---DROP SEQUENCE inventory_sequence;

CREATE SEQUENCE inventory_sequence;


--
-- Table structure for table staff
--

CREATE TABLE staff (
  staff_id SMALLINT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id INT NOT NULL,
  picture BLOB DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  store_id INT NOT NULL,
  active SMALLINT DEFAULT 1 NOT NULL,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) DEFAULT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_staff PRIMARY KEY  (staff_id),
  CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id)
);

CREATE  INDEX idx_fk_staff_store_id ON staff(store_id);


CREATE  INDEX idx_fk_staff_address_id ON staff(address_id);


---DROP SEQUENCE inventory_sequence;

CREATE SEQUENCE staff_sequence;



--
-- Table structure for table store
--

CREATE TABLE store (
  store_id INT NOT NULL,
  manager_staff_id SMALLINT NOT NULL,
  address_id INT NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_store PRIMARY KEY  (store_id),
  CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ,
  CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id)
);

CREATE  INDEX idx_store_fk_manager_staff_id ON store(manager_staff_id);


CREATE  INDEX idx_fk_store_address ON store(address_id);


---DROP SEQUENCE store_sequence;

CREATE SEQUENCE store_sequence;



--
-- Table structure for table payment
--

CREATE TABLE payment (
  payment_id int NOT NULL,
  customer_id INT  NOT NULL,
  staff_id SMALLINT NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date TIMESTAMP NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_payment PRIMARY KEY  (payment_id),
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ,
  CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE  INDEX idx_fk_staff_id ON payment(staff_id);

CREATE  INDEX idx_fk_customer_id ON payment(customer_id);


---DROP SEQUENCE payment_sequence;

CREATE SEQUENCE payment_sequence;


CREATE TABLE rental (
  rental_id INT NOT NULL,
  rental_date TIMESTAMP NOT NULL,
  inventory_id INT  NOT NULL,
  customer_id INT  NOT NULL,
  return_date TIMESTAMP DEFAULT NULL,
  staff_id SMALLINT  NOT NULL,
  last_update TIMESTAMP NOT NULL,
  CONSTRAINT pk_rental PRIMARY KEY (rental_id),
  CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ,
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

CREATE INDEX idx_rental_fk_inventory_id ON rental(inventory_id);

CREATE INDEX idx_rental_fk_customer_id ON rental(customer_id);

CREATE INDEX idx_rental_fk_staff_id ON rental(staff_id);

CREATE UNIQUE INDEX   idx_rental_uq  ON rental (rental_date,inventory_id,customer_id);


---DROP SEQUENCE payment_sequence;

CREATE SEQUENCE rental_sequence;


-- FK CONSTRAINTS
ALTER TABLE customer ADD CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE inventory ADD CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE staff ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE payment ADD CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL;


-- TO DO PROCEDURES
