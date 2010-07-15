require 'active_record/fixtures'
Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "frequencies")  
Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "time_lengths")  
Fixtures.create_fixtures("#{Rails.root}/db/training", "recommendation_definitions")  
Fixtures.create_fixtures("#{Rails.root}/db/training", "recommendation_answer_definitions")  
System.bootstrap

puts 'to create a training district, run script/runner CreateTrainingDistrict.generate_one'
