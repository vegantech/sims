-- See news_admin for another approach to designate which users should have access to all students.
-- Here you can replace the groupID with the id's of groups which should have such access, remove the /* and */ and the first
-- select line if you want to do it this way.   Otherwise it assumes all users should have access
-- to all students


select personid from useraccount
/*
SELECT     personid as district_user_id
FROM          dbo.UserGroupMember
inner join useraccount on usergroupmember.userid = useraccount.userid
WHERE       (groupID IN (1, 12, 3))
*/