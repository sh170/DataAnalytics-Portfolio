
/*1.Finding Top Traffic Sources*/

select utm_source,utm_campaign,http_referer,count(distinct website_session_id) as session_counts from website_sessions
where created_at < '2012-04-12'
group by 1,2,3
order by 4 desc;

/*2.Traffic Source conversion rate*/

select count(distinct website_sessions.website_session_id) as sessions, count(distinct order_id) as orders_count, 
count(distinct order_id)/count(distinct website_sessions.website_session_id) as sessions_convr
from website_sessions
left join orders on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at < '2012-04-12' and utm_source='gsearch' and utm_campaign='nonbrand';

/*3.Traffic Source Trending*/

select 
--year(created_at) as yr,
--week(created_at) as wk,
min(date(created_at)) as week_start,
count(distinct website_session_id ) as sesions
from website_sessions
where created_at < '2012-05-12' and utm_source='gsearch' and utm_campaign='nonbrand'
group by year(created_at) ,
week(created_at) ;

/*Bid optimization for Paid Traffic*/
select website_sessions.device_type ,count(distinct website_sessions.website_session_id) as sessions, count(distinct order_id) as orders_count, 
count(distinct order_id)/count(distinct website_sessions.website_session_id) as sessions_convr
from website_sessions
left join orders on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at < '2012-05-11' and utm_source='gsearch' and utm_campaign='nonbrand'
group by 1;

/*Trend Analysis after Bidding more on Bidding more on Desktop data type*/

select 
--year(created_at) as yr,
--week(created_at) as wk,
min(date(created_at)) as week_start,
count(case when device_type='desktop' then website_session_id end) as dktop_sesions,
count(case when device_type='mobile' then website_session_id end) as mob_sesions
from website_sessions
where created_at < '2012-06-09' and utm_source='gsearch' and utm_campaign='nonbrand'
group by year(created_at),
week(created_at) ;