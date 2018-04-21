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
order by c.last_name;

#7a
select f.title from film f
inner join language l
on f.language_id=l.language_id
where l.name="English" and (f.title like("K%") or f.title like("Q%"));
#7b:
select actor_name from film_actor fa
inner join actor a
on a.actor_id = fa.actor_id
where film_id=(select film_id from film where title="Alone Trip");
#7c:
select c.first_name, c.last_name, c.email from customer c 
inner join
	(select a.address_id from address a
	inner join(
		select ci.city, ci.city_id from city ci
		inner join country co
		on ci.country_id = co.country_id
		where co.country="Canada") coci
	on a.city_id=coci.city_id) ca
on ca.address_id=c.address_id;
#7d:
select title from film where film_id in(
select film_id from film_category where category_id= (
select category_id from category where name="Family"));
#7e:
select title from film f 
inner join 
	(select film_id, sum(c) as rental_count from inventory i
	inner join (
		select inventory_id, count(inventory_id) as c from rental r 
        group by inventory_id) invc
	on invc.inventory_id = i.inventory_id
	group by film_id) fc
on fc.film_id=f.film_id
order by rental_count desc;
#7f:
select store_id, sum(amount) as total from payment p
inner join (
	select rental_id, r.inventory_id, store_id from rental r
	inner join inventory i
	on r.inventory_id = i.inventory_id) rr
on rr.rental_id = p.rental_id
group by store_id;
#7g:
select store_id, address, city, country from country co
inner join(
	select store_id, address, city, country_id from city ci
	inner join (
		select store_id,address,city_id from store s 
		inner join address a 
		on a.address_id=s.address_id) aa
	on aa.city_id = ci.city_id) cc
on co.country_id=cc.country_id;
#7h:
select name, sum(amount) as total from category c
inner join film_category fc
on fc.category_id = c.category_id
inner join inventory i
on i.film_id=fc.film_id
inner join rental r
on r.inventory_id=i.inventory_id
inner join payment p
on p.rental_id=r.rental_id
group by name
order by total desc
limit 5;


#8a:

create view a as
select name, sum(amount) as total from category c
inner join film_category fc
on fc.category_id = c.category_id
inner join inventory i
on i.film_id=fc.film_id
inner join rental r
on r.inventory_id=i.inventory_id
inner join payment p
on p.rental_id=r.rental_id
group by name
order by total desc
limit 5;
#8b:
select * from a;
#8c: 
drop view a;
