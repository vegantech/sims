# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'active_record/fixtures'
%w(frequencies time_lengths recommendation_definitions recommendation_answer_definitions).each do |f|
ActiveRecord::Fixtures.create_fixtures(Rails.root.join("db","training"),f)
end
System.bootstrap

puts 'to create a training district, run rails runner CreateTrainingDistrict.generate_one'
