select  enrollment.grade,school.schoolID as district_school_id, 
enrollment.personid as district_student_id, calendar.endYear as end_year
from enrollment 
inner join student on enrollment.personid = student.personid and student.calendarid = enrollment.calendarid
inner join calendar on  enrollment.calendarid = calendar.calendarid 
inner join school on calendar.schoolid = school.schoolid
where enrollment.endDate is null or enrollment.enddate > dateadd(month,-3,getdate())
and student.activeyear =1

