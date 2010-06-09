set nocount on
select personID as district_user_id from useraccount
where username in ('content_admin1', 'content_admin2')  
