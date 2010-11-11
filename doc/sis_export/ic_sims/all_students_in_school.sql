select personID as district_user_id,
schoolid as district_school_id,
null as principal,
null as grade
from employmentassignment
where 
teacher=1 or specialed=1 or behavior =1 or supervisor=1 or advisor=1
  
