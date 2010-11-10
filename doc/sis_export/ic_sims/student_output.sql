select distinct  stateid as id_state, student.personID as district_student_id, studentNumber as number,
firstName as first_name,
cast(replace(middleName,'"',' ') as varchar(60)) as middle_name,
cast(replace(lastname,',',' ') as varchar(60))as last_name,
suffix as suffix, 
birthdate, 
esl.esl, enrollment.specialedstatus as special_ed
from student 
left outer join 
   (SELECT     dbo.CustomStudent.personID, CASE customstudent.value WHEN 'E' THEN 1 ELSE NULL END AS esl
                            FROM          dbo.CustomStudent INNER JOIN
                                                   dbo.CampusAttribute ON dbo.CampusAttribute.attributeID = dbo.CustomStudent.attributeID AND 
                                                   dbo.CampusAttribute.element = 'ESL Status') AS esl ON dbo.student.personID = esl.personID

left outer join enrollment on
enrollment.active=1 and enrollment.enddate is null and enrollment.personid = student.personid


where activeyear = 1

