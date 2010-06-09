-- replace news1, news2, news3 with the usernames of users that you want to have the news_admin role
set nocount on
select personID as district_user_id from useraccount
where username in ('news1', 'news2', 'news3')