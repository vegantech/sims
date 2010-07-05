require 'active_record/fixtures'
Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "frequencies")  
Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "time_lengths")  
System.bootstrap

puts 'to create a training district, run script/runner CreateTrainingDistrict.generate_one'
