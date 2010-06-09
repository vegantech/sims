@echo off

rem set this to the name of your primary IC database, it is probably the name or abbreviation of your district
set db_name= YOUR_DB_NAME
del district_upload.zip


rem sqlcmd -d %db_name% -i all_students_in_district.sql -o all_students_in_district.csv -s ,

rem sqlcmd -d %db_name% -i district_admins.sql -o district_admins.csv -s ,
rem Remove the rem from above if you're not doing district admins manually


sqlcmd -d %db_name% -i school_output.sql -o schools.csv -s ,
sqlcmd -d %db_name% -i enrollment_output.sql -o enrollments.csv -s ,
sqlcmd -d %db_name% -i regular_users.sql -o regular_users.csv -s ,
sqlcmd -d %db_name% -i user_output.sql -o users.csv -s ,
sqlcmd -d %db_name% -i student_output.sql -o students.csv -s ,
sqlcmd -d %db_name% -i all_students_in_school.sql -o all_students_in_school.csv -s ,


fbzip -a "district_upload.zip" ".\*.csv"
echo del *.csv

rem create a user (within SIMS) with the username district_upload  replace the password below
echo curl --user district_upload:your_created_password https://your_district_abbrev.simspilot.org/scripted/district_upload -Fupload_file=@district_upload.zip -k
rem replace the your_district_abbrev in the url above, uncomment to automatically upload the zip
echo %TIME%

