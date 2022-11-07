/*Write a query to create a stored procedure to get the details of all passengers flying between a range of routes defined in run time.
 Also, return an error message if the table doesn't exist.*/
create database air_cargo; 
Use air_cargo;

DROP PROCEDURE IF EXISTS passenger_with_parameters;
delimiter &&
CREATE PROCEDURE passenger_with_parameters(in pinitial int, pfinal int)
BEGIN
select customer.customer_id,customer.first_name,customer.last_name,customer.gender,cus- tomer.date_of_birth, passengers_on_flights.route_id from customer
inner join passengers_on_flights
on passengers_on_flights.customer_id=customer.customer_id
where passengers_on_flights.route_id between pinitial and pfinal;
end &&
call passenger_with_parameters(4,15);


DROP PROCEDURE IF EXISTS table_exists; 
delimiter &&
CREATE PROCEDURE table_exists(IN in_db text, IN in_table text)
begin
call sys.table_exists(in_db,in_table, @out_exists); SELECT @out_exists;
#SELECT @table_type := @out_exists;
if @out_exists = "" then
signal sqlstate "45000"
set message_text ="Table does not exists!"; end if;
end &&
call table_exists('air_cargo','customers');