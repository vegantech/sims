FactoryGirl.define do
  sequence :username do |n|
    "user#{n}#{Time.now.to_i}"
  end

  sequence :abbrev do |a|
    "test#{a}#{Time.now.to_i}"
  end

  sequence :name do |a|
    "name#{a}#{Time.now.to_i}"
  end

  sequence :title do |a|
    "#{a}#{Time.now.to_i} Title"
  end
  factory :team_consultation do |_tc|
  end

  factory :consultation_form do |_cf|
  end

  factory :consultation_form_concern do |_cfc|
  end

  factory :user do
   username
   password {username}
   password_confirmation {password}
   last_name "Last_Name"
   district_user_id ''
   first_name {"First#{username}"}
   association :district
  end

  factory :enrollment do |e|
    e.grade "01"
    e.association :student
    e.association :school
  end

  factory :group do |g|
    g.title
    g.association :school
    g.district_group_id ''
  end

  factory :tier do |t|
    t.title "Some tier"
  end

  factory :student do |s|
    s.last_name "Last"
    s.first_name "First"
    s.association :district
    s.district_student_id ''
  end

  factory :district do
    abbrev
    name { "#{abbrev} District"}
  end

  factory :school do |s|
    sequence(:name) {|n| "#{n} School"}
    s.association :district
  end

  factory :intervention_participant do |ip|
    ip.association :user
    ip.association :intervention
    ip.role {InterventionParticipant::PARTICIPANT}
  end

  factory :intervention do |i|
    i.association :user
    i.association :student
    i.frequency_multiplier 1
    i.association :frequency
    i.time_length_number 1
    i.association :time_length
    i.association :intervention_definition
    i.start_date Date::civil(2008, 11, 1)
    i.end_date Date::civil(2008, 12, 1)
  end

  factory :intervention_definition do |id|
    id.title
    id.description {|i| i.title + "Description"}
    id.association :time_length
    id.association :frequency
    id.time_length_num 1
    id.frequency_multiplier 1
    id.association :intervention_cluster
    id.association :tier
  end

  factory :intervention_cluster do |ic|
    ic.title
    ic.description {|i| i.title + "Description"}
    ic.association :objective_definition
  end

  factory :objective_definition do |od|
    od.title
    od.description {|i| i.title + "Description"}
    od.association :goal_definition
  end

  factory :goal_definition do |gd|
    gd.title
    gd.description {|i| i.title + "Description"}
    gd.association :district
  end

  factory :quicklist_item do |qi|
    qi.association :intervention_definition
    qi.association :school
    #qi.association :district (it's one or the other)
  end

  # TODO: validate time length
  factory :time_length do |tl|
    tl.days 2
    tl.title "Default"
  end

  factory :frequency do |f|
    f.title 'Freq Title'
  end

  factory :probe_definition do |f|
    f.title
    f.description 'Probe Description'
  end

  factory :intervention_probe_assignment do |f|
    f.association :probe_definition
    f.association :intervention
    f.first_date "2005-01-01"
    f.end_date "2006-01-01"
  end

  factory :student_comment do |f|
    f.association :student
    f.association :user
    f.body  "This is the factory generated note"
  end
  
  factory :custom_flag do |f|
    f.association :student
    f.reason "Factory Reason"
    f.category "attendance"
  end
end
