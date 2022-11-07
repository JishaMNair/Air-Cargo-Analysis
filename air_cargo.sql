create database air_cargo; 
Use air_cargo;

create table route_details( route_id int not null,
unique (route_id),
flight_num int not null,
check (flight_num>0),
origin_airport text not null,
destination_airport text not null, 
aircraft_id text not null, 
distance_miles int not null check (distance_miles>0)
);

/*Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. 
Take data from the passengers_on_flights table.*/

select * from passengers_on_flights where route_id
between 01 and 25;

/*Write a query to extract the customers who have registered and booked a ticket. 
Use data from the customer and ticket_details tables.*/

select ticket_details.customer_id, customer.first_name, customer.last_name from customer
inner join ticket_details
on ticket_details.customer_id = customer.customer_id;

#Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.*/
select ticket_details.customer_id, customer.first_name, customer.last_name, ticket_details.brand from customer
inner join ticket_details
on ticket_details.customer_id = customer.customer_id
where brand=‘Emirates’;

#Write a query to create and grant access to a new user to perform operations on a database.
CREATE USER 'PREETY'@'host_name' IDENTIFIED BY 'user_password';
GRANT ALL PRIVILEGES
ON air_cargo.passengers_on_flight TO PREETY@host_name;
SHOW GRANTS FOR PREETY@host_name;

#Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles.
DROP PROCEDURE IF EXISTS routes_procedure; delimiter &&
CREATE PROCEDURE routes_procedure()
BEGIN
select * from routes
where distance_miles>2000; end &&
call routes_procedure();

/*Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. 
The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel (IDT) for >2000 
AND <=6500, and long-distance travel (LDT) for >6500.*/
DROP PROCEDURE IF EXISTS distance_procedure; DELIMITER &&
CREATE PROCEDURE distance_procedure()
BEGIN
DECLARE c_distance_miles int ;
DECLARE c_aircraft_id text DEFAULT " ";
declare category varchar(45);
DECLARE done INT DEFAULT 0;
DECLARE cursor_distance CURSOR FOR SELECT distance_miles,aircraft_id FROM routes; DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
OPEN cursor_distance;
DROP TEMPORARY TABLE IF EXISTS results_table;
CREATE TEMPORARY TABLE results_table( aircraft_id varchar(100),
distance_miles int,
category varchar(100)
); miles_loop:LOOP
FETCH cursor_distance INTO c_distance_miles,c_aircraft_id;
IF done=1 THEN
LEAVE miles_loop;
END IF;
if (c_distance_miles>=0 and c_distance_miles<=2000) then set category="short distance travel (SDT)";
elseif (c_distance_miles>2000 and c_distance_miles<=6500) then set category="intermediate distance travel (IDT)";
elseif c_distance_miles>=6500
then set category= "long-distance travel (LDT)";
end if;
INSERT INTO results_table (SELECT c_aircraft_id as aircraft_id,c_distance_miles as distance_miles,category);
SELECT c_aircraft_id as aircraft_id,c_distance_miles as distance_miles,category; END LOOP miles_loop;
CLOSE cursor_distance;
END &&
DELIMITER ;
call distance_procedure(); select * from results_table;
