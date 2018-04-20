use sakila;
select * from actor;
#1a
select first_name,last_name from actor;
#1b
#alter table actor add column actor_name varchar(50);
update actor set actor_name = concat(upper(first_name), ' ', upper(last_name));
select actor_name from actor;

#2a
select actor_name from actor where first_name like("Joe");
#2b
select actor_name from actor where last_name like("%gen%");
#2c
select actor_name from actor where last_name like("%li%") order by last_name,first_name;
#2d
select country_id, country from country where country in("Afghanistan", "Bangladesh", "China");

#3a/b
alter table actor add column middlename blob;
#3c
alter table actor drop column middlename;

#4a
select last_name, count(1) as 'count' from actor group by last_name;
#4b
select * from(
select last_name, count(1) as name_count from actor group by last_name) as x
where name_count >= 2;
#4c
update actor set first_name = "HARPO" where first_name = "groucho" and last_name = "williams";
update actor set actor_name = concat(upper(first_name), ' ', upper(last_name));
#4d
update actor set first_name = case
		when first_name="HARPO" then "GROUCHO"
        when first_name="GROUCHO" then "GROUCHO" 
		else "MUCHO GROUCHO"
    END
where actor_id = 172;
update actor set actor_name = concat(upper(first_name), ' ', upper(last_name));

#5
select COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = "address";
create table address2 (
	address_id smallint, address varchar(50), address2 varchar(50),
    district varchar(20), city_id smallint, postal_code varchar(10),
    phone varchar(20), location geometry, last_update timestamp
);

#6a
select s.first_name, s.last_name, a.address from staff s inner join address a on a.address_id = s.address_id;
#6b
select s.last_name, sum(p.amount) from staff s 
inner join payment p 
on p.staff_id = s.staff_id
where p.payment_date between '2005-08-01 00:00:00' and '2005-08-31 23:59:59'
group by s.last_name;
#6c
select f.title, count(fa.film_id) from film f 
inner join film_actor fa 
on fa.film_id = f.film_id 
group by f.title;
#6d
select f.title, count(f.title) from inventory i
inner join film f 
on i.film_id = f.film_id
where f.title="Hunchback Impossible";
#6e
select c.first_name, c.last_name, sum(p.amount) from customer c
inner join payment p 
on p.customer_id = c.customer_id
group by c.customer_id
order by c.last_name

