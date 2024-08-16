create database projectsql2;
use projectsql2;
-- Question 1: - We need to find out the total visits to all restaurants under all alcohol categories available.
select*from userprofile;
select*from geoplaces2;
select distinct userID from rating_final;

select Alcohol_category,sum(no_of_visitors) Total_visitors from(
Select gp.placeID as Restaraunt_Id, gp.alcohol as Alcohol_category ,count(up.userID) as no_of_visitors
from userprofile up join rating_final rf using(userID)
join geoplaces2 gp using (placeID)
group by gp.alcohol,gp.placeID)t
group by ALcohol_category ;

select distinct alcohol from geoplaces2;

-- Question 2: -Let's find out the average rating according to alcohol and price so that we can understand the rating in respective price categories as well.
select Category,Price, avg(Rating) Avg_Rating from(
select rf.rating Rating,gp.Alcohol as Category,gp.price Price from rating_final rf join geoplaces2 gp using (placeID))t
group by Category, Price;

-- Question 3:  Let’s write a query to quantify that what are the parking availability as well in different alcohol categories along with the total number of restaurants.
select * from geoplaces2;
select * from chefmozparking;
select alcohol as Category, parking_lot parking_availability, count(gp.placeid) as no_of_restraunts
from geoplaces2 gp
join chefmozparking cp
using(placeid)
group by alcohol, parking_lot;

-- Question 4: -Also take out the percentage of different cuisine in each alcohol type.

select *,(cnt_rcuisine/cat_cnt)*100 as perc_cuisine from( 
select *,sum(cnt_rcuisine)over(partition by alcohol) cat_cnt from(
select alcohol,rcuisine,count(*) as cnt_rcuisine 
from geoplaces2 gp join chefmozcuisine using(placeid)
group by alcohol,rcuisine)t)t2;

-- Let us now look at a different prospect of the data to check state-wise rating.


-- Questions 5: - let’s take out the average rating of each state.
select distinct state,avg(rating)over(partition by state) as Avg_Rating from(
select gp.state state,rf.rating from rating_final rf join geoplaces2 gp using(placeid)
group by rf.placeid,rf.rating,gp.state 
having state not like '?')t;



-- Questions 6: -' Tamaulipas' Is the lowest average rated state. Quantify the reason why it is the lowest rated by providing the summary
--  on the basis of State, alcohol, and Cuisine.
-- select * from geoplaces2 join rating_final using(placeid) where state='Tamaulipas'
#1 
select count(area)  from(
select * from geoplaces2 join rating_final using(placeid) where state='Tamaulipas')t
where area like 'closed'; 
#No. of area which is closed (62) greater the no. of area which is open(26)

#2
select count(address) from(
select * from geoplaces2 join rating_final using(placeid) where state='Tamaulipas')t
where address like '?'; #Address of almost 36 restaraunts is not given properly.
#No_Alcohol_Served in all the restaraunts

#3
select count(smoking_area) from(
select * from geoplaces2 join rating_final using(placeid) where state='Tamaulipas')t
where smoking_area like 'none';
#No separate smoking zone in the restaraunts

-- Question 7:  - Find the average weight, food rating, and service rating of the customers who have visited KFC and 
-- tried Mexican or Italian types of cuisine, and also their budget level is low.
-- We encourage you to give it a try by not using joins.
select*from userprofile;
#using group by
select name, up.userid,avg(weight),food_rating,service_rating 
from userprofile up join usercuisine using(userid) join rating_final using (userid) join geoplaces2 using (placeid)
where name like '%KFC%' and( Rcuisine like '%Mexican%%' or Rcuisine like '%Italian%%' )and budget='low'
group by name,food_rating,service_rating,up.userid ;

#Without using group by
select up.userid, avg(weight),
rf.food_rating,rf.service_rating from 
userprofile up, usercuisine uc,rating_final rf,geoplaces2 gp
where
up.userid=uc.userid
and 
uc.userid=rf.userid
and 
rf.placeid=gp.placeid
and
gp.name like '%KFC%'
and 
(uc.Rcuisine like '%Mexican%' or uc.Rcuisine like '%Italian%')
and
up.budget='low'
group by up.userid,rf.food_rating,rf.service_rating;

#Extra questions:
# 1.Retrieve the Top 5 Places with the Highest Average Ratings with their parking_availability,smoking_zone,cuisine served.
select gp.placeid,gp.smoking_area,cp.parking_lot,cc.Rcuisine,rf.rating from
geoplaces2 gp join chefmozparking cp using(placeid) join chefmozcuisine cc using(placeid) join rating_final rf using(placeid)
order by rating desc limit 5;

-- 2.List Places Offering Different Payment Options with service Ratings highest:

select Placeid,count(payment_mode) payment_options, Service_rating from( 
select distinct rf.placeid Placeid,up.Upayment as payment_mode,rf.service_rating Service_rating from rating_final rf join userpayment up using(userid)
where rf.service_rating>=2)t
group by  Placeid, Service_rating 
limit 6;







