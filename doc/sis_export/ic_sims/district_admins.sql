-- replace admin with the usernames of users that you want to have the district_admin role

set nocount on
select personID as district_user_id from useraccount
where username in ('admin', 'admin2')
