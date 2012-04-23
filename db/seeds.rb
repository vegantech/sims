# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'active_record/fixtures'
Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "frequencies")
Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "time_lengths")
Fixtures.create_fixtures("#{Rails.root}/db/training", "recommendation_definitions")
Fixtures.create_fixtures("#{Rails.root}/db/training", "recommendation_answer_definitions")
System.bootstrap

puts 'to create a training district, run rails runner CreateTrainingDistrict.generate_one'
