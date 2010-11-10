declare @district_key as varchar(40)
declare @system_key as varchar(40)
declare @password as varchar(40)
declare @salt_seed as varchar(40)
set @district_key = ''
set @system_key = ''
set @salt_seed = 'e'+ cast(100* RAND( (DATEPART(mm, GETDATE()) * 100000 )
           + (DATEPART(ss, GETDATE()) * 1000 )
           + DATEPART(ms, GETDATE())) as varchar)



select useraccount.personid as district_user_id, username,
cast(replace(firstName,'"',' ') as varchar(60)) as first_name, middleName as middle_name,
lastName as last_name,  suffix as suffix,
email,
cast(hashbytes('sha1',@system_key + LOWER([password]) +
 @district_key +(cast(userID as varchar)+  @salt_seed))
as binary(40)
)
 as passwordhash,
(cast(userID as varchar)+  @salt_seed) as salt
 from useraccount INNER JOIN
dbo.[Identity] ON dbo.UserAccount.personID = dbo.[Identity].personID INNER JOIN
dbo.Person ON dbo.UserAccount.personID = dbo.Person.personID AND 
dbo.[Identity].identityID = dbo.Person.currentIdentityID
left outer join contact on useraccount.personid = contact.personid
where disable=0
-- and dbo.person.staffnumber is not null

