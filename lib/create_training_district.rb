class CreateTrainingDistrict
  require 'fastercsv'
  def self.generate
    generate_one
    2.upto(20){ |i| generate_one(i.to_s)}

  end

  def self.generate_one(num = '')
   
    abbrev = "training#{num}"
    wi = State.find_by_abbrev('wi')
    d=wi.districts.find_by_abbrev(abbrev)
    if d.present?
      d.schools.destroy_all
      d.tiers.delete_all
      d.destroy
    end
    td=wi.districts.create!(:abbrev=>abbrev, :name => abbrev.capitalize)
    #alpha elementary
    alpha_elem=td.schools.create!(:name => 'Alpha Elementry')

    oneschool = td.users.create!(:username => 'oneschool', :password => 'oneschool', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'User')

    melody = td.users.create!(:username => 'melody', :password => 'melody', :email => 'shawn@simspilot.org', :first_name => 'Melody', :last_name => 'TrebleCleff')
    
    training_homeroom = alpha_elem.groups.create!(:title => "Training Homeroom")
    other_homeroom = alpha_elem.groups.create!(:title => 'Other Group')
    oneschool.groups << training_homeroom
    oneschool.groups << other_homeroom

    melody.groups << other_homeroom
    melody.schools << alpha_elem
    oneschool.schools << alpha_elem
    

    
    oneschool.save!
    melody.save!
    training_team = alpha_elem.school_teams.create!(:name => "Training", :contact => oneschool.id)
    
    #oneschool
    #alphaprin
    #students
    
    alphaprin = td.users.create!(:username => 'alphaprin', :password => 'alphaprin', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Principal')
    alphaprin.user_school_assignments.create!(:admin => true, :school => alpha_elem)
    alphaprin.special_user_groups.create!(:school=>alpha_elem, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :is_principal => true, :district => td)

    training_team.school_team_memberships.create!(:user => alphaprin, :contact => false)
    
    content_admin = td.users.create!(:username => 'content_builder', :password => 'content_builder', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Content Admin')

    other_team = alpha_elem.school_teams.create!(:name => "Other Team", :contact => alphaprin.id)
    td.flag_categories.create!({"category"=>"math", "threshold"=>"30", "existing_asset_attributes"=>{"qqq"=>""}, "new_asset_attributes"=>[{"name"=>"Math Core Practice (training sample link)", "url"=>"#"}]})

    
    self.generate_interventions(td)
    self.generate_checklist_definition(td)

    Role.find_by_name("regular_user").users << [alphaprin,oneschool]
    Role.find_by_name("school_admin").users << alphaprin
    Role.find_by_name("content_admin").users << content_admin

    self.generate_students(td, alpha_elem, training_homeroom)
    self.generate_other_students(td,alpha_elem, other_homeroom)
    td
    
  end

  def self.generate_interventions(district)
    goalhash = {}
    objectivehash = {}
    clusterhash = {}
    definitionhash = {}
    probe_hash = {}
    
    oldtiers=[781073596, 781073597, 781073598]
    tier = district.tiers.create!(:title=>'First tier')
    second_tier = district.tiers.create!(:title=>'Second tier')
    third_tier = district.tiers.create!(:title=>'Third tier')
    
    FasterCSV.table("db/training/goal_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      newcd= district.goal_definitions.create!(ckhash)
      goalhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("db/training/objective_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:goal_definition_id]= goalhash[ck[:goal_definition_id]]
      newcd= ObjectiveDefinition.create!(ckhash)
      objectivehash[ck[:id]]=newcd.id
    end

    FasterCSV.table("db/training/intervention_clusters.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:objective_definition_id]= objectivehash[ck[:objective_definition_id]]
      newcd= InterventionCluster.create!(ckhash)
      clusterhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("db/training/intervention_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:intervention_cluster_id]= clusterhash[ck[:intervention_cluster_id]]
      if [1037859175,1037859176,1037859177].include?(ck[:intervention_cluster_id].to_i)
        mytier = [tier.id,second_tier.id,third_tier.id][oldtiers.index(ck[:tier_id].to_i)]
        newcd= InterventionDefinition.create!(ckhash.merge(:tier_id => mytier))
      else
        newcd= InterventionDefinition.create!(ckhash.merge(:tier_id => tier.id))
      end
      definitionhash[ck[:id]]=newcd.id
    end


    FasterCSV.table("db/training/probe_definitions_monitors.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      newcd= district.probe_definitions.create!(ckhash)
      probe_hash[ck[:id]]=newcd.id
    end

    FasterCSV.table("db/training/recommended_monitors.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:intervention_definition_id]= definitionhash[ck[:intervention_definition_id]]
      ckhash[:probe_definition_id]= probe_hash[ck[:probe_definition_id]]
      newcd= RecommendedMonitor.create!(ckhash)
    end

    FasterCSV.table("db/training/assets.csv").each do |ck|
      
      old_id = ck[:attachable_id]
      case ck[:attachable_type]
      when 'ProbeDefinition'
        newid=probe_hash[old_id]
      when 'InterventionDefinition'
        newid = definitionhash[old_id]
      else
        newid = nil
      end

      if ck[:url].include?("/")
        url = ck[:url]
      else
        url = "/file/#{ck[:url]}"
      end
      Asset.create!(:attachable_type => ck[:attachable_type], :attachable_id => newid, :url => url, :name => ck[:name]) if newid.present?
        

    end


    
    


  end

  def self.generate_checklist_definition(district)
    checklisthash = {}
    questionhash = {}
    elementhash = {}
    
    FasterCSV.table("db/training/checklist_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:active]=false
      
      newcd= district.checklist_definitions.create!(ckhash)
      checklisthash[ck[:id]]=newcd.id
    end

    FasterCSV.table("db/training/question_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:checklist_definition_id]= checklisthash[ck[:checklist_definition_id]]
      newcd= QuestionDefinition.create!(ckhash)
      questionhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("db/training/element_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:question_definition_id]= questionhash[ck[:question_definition_id]]
      newcd= ElementDefinition.create!(ckhash)
      elementhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("db/training/answer_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:value] ||=0
      ckhash[:element_definition_id]= elementhash[ck[:element_definition_id]]
      newcd= AnswerDefinition.create!(ckhash)
    end






  end

  def self.generate_other_students(district,school,group)
    first_names = IO.readlines('test/fixtures/common_first_names.txt')
    last_names = IO.readlines('test/fixtures/common_last_names.txt')
    grades= ['K', '1', '2', '3', '4', '5'] 
    
    31.upto(60) do |i|
      esl=rand(3) == 1
      special_ed = rand(3) == 1
      first_name = first_names[(i%50) -1 + 50*(i %2)].strip
      last_name = last_names[i-1].capitalize.strip
      s=Factory(:student, :district => district, :birthdate=>10.years.ago, :first_name => first_name, :last_name => last_name,
        :number => (i-1).to_s, :esl => esl, :special_ed => special_ed)
      s.enrollments.create!(:school => school, :grade => grades[i%6])
      s.groups << group
      s.system_flags.create!(:category=>"languagearts", :reason => "1-edits writing, 1-revises writing, 1-applies
        comprehension strategies to independent reading") if rand(10) == 1
      s.system_flags.create!(:category=>"math", :reason => "1- word problem assessment ") if i.odd?
      s.system_flags.create!(:category=>"suspension", :reason => "2 office referrals") if rand(10) == 1
      s.system_flags.create!(:category=>"attendance", :reason => "3 times tardy ") if rand(10) == 1
    end
 

  end


  



  
  def self.generate_students(district,school,group)
    first_names = IO.readlines('test/fixtures/common_first_names.txt')
    last_names = IO.readlines('test/fixtures/common_last_names.txt')
    
    1.upto(30) do |i|
      s=Factory(:student, :district => district, :birthdate=>10.years.ago, :first_name => first_names[i-1+ 50*(i %2)].strip, :last_name => "#{i.to_s.rjust(2,'0')}-#{last_names[i-1].capitalize.strip}",
        :number => (i-1).to_s)
      s.enrollments.create!(:school => school, :grade => 5)
      s.groups << group
      s.system_flags.create!(:category=>"languagearts", :reason => "1-edits writing, 1-revises writing, 1-applies
        comprehension strategies to independent reading")
      s.system_flags.create!(:category=>"math", :reason => "1- word problem assessment ") if rand(10) == 1
      s.system_flags.create!(:category=>"suspension", :reason => "2 office referrals") if rand(10) == 1
      s.system_flags.create!(:category=>"attendance", :reason => "3 times tardy ") if rand(10) == 1
      add_extended_profile(s)
     
    end
  end

  def self.add_extended_profile(student)
    student.create_ext_summary(
    :streetAddress => "123 Training Blvd Apt #{student.first_name[0..1]}",
    :cityStateZip => "Madison, WI 53704",
    :HomeLanguage => "English",
    :mealstatus => "F",
    :englishProficiency => 7,
    :specialEdStatus => "N",
    :singleParent => false,
    :raceEthnicity => "W",
    :suspensions_in => 0,
    :suspensions_out => 0,
    :years_in_district => 7,
    :school_changes => 2,
    :years_at_current_school => 4,
    :previous_school_name => "Previous Elementary",
    :current_attendance_rate => 94.14,
    :previous_attendance_rate => 94.58,
    :esl => false,
    :tardies => 3
    )

    student.ext_adult_contacts.create!(
    :relationship => "Parent",
    :guardian => true, 
    :firstName => "Plato", 
    :lastName => student.last_name, 
    :streetAddress => "123 Training Blvd Apt #{student.first_name[0..1]}",
    :cityStateZip => "Madison, WI 53704",
    :cellPhone => "(608)555-1212"
    )
   
    student.ext_siblings.create!(
    :first_name => "Brother", 
    :last_name => student.last_name, 
    :student_number => "123456",
    :age => 12,
    :grade => "07",
    :school_name => "Example Middle"
    )

    student.ext_test_scores.create!(
    :name => "PMA 1 Total",
    :date => "2001-10-06",
    :result => 3
    )
    
    student.ext_test_scores.create!(
    :name => "PMA 2 Total",
    :date => "2002-10-06",
    :result => 2
    )



    student.ext_test_scores.create!(
    :name => "WKCE 4 Language Arts",
    :date => "2004-10-06",
    :result => 3
    )

    student.ext_test_scores.create!(
    :name => "WKCE 4 Math",
    :date => "2004-10-06",
    :result => 2
    )


    student.ext_test_scores.create!(
    :name => "WKCE 4 Science",
    :date => "2004-10-06",
    :result => 3
    )

    student.ext_test_scores.create!(
    :name => "WKCE 4 Social Studies",
    :date => "2004-10-06",
    :result => 4
    )

    student.ext_test_scores.create!(
    :name => "WKCE 4 Reading",
    :date => "2004-10-06",
    :result => 3
    )

    student.ext_test_scores.create!(
    :name => "WKCE 3 Math",
    :date => "2003-10-06",
    :result => 3
    )


    student.ext_test_scores.create!(
    :name => "WKCE 3 Reading",
    :date => "2004-10-06",
    :result => 3
    )

   



    

   
    student.ext_test_scores.create!(
    :name => "PLAA K Phonemic Awareness",
    :date => "2002-09-01",
    :result => 2
    )
 
    student.ext_test_scores.create!(
    :name => "PLAA K Text Reading Level",
    :date => "2002-09-01",
    :result => 2,
    :scaleScore => 1
    )

    student.ext_test_scores.create!(
    :name => "PLAA K Concepts About Print",
    :date => "2003-04-01",
    :result => 3
    )

    student.ext_test_scores.create!(
    :name => "PLAA K Hearing Sounds in Words",
    :date => "2003-04-01",
    :result => 1
    )
 
    
    student.ext_test_scores.create!(
    :name => "PLAA K Lower Case Letters",
    :date => "2003-04-01",
    :result => 2
    )
 
    
    student.ext_test_scores.create!(
    :name => "PLAA K Phonemic Awareness",
    :date => "2003-04-01",
    :result => 3
    )
 

    student.ext_test_scores.create!(
    :name => "PLAA K Sound Word",
    :date => "2003-04-01",
    :result => 2
    )
 
    student.ext_test_scores.create!(
    :name => "PLAA K Text Reading Level",
    :date => "2003-04-01",
    :result => 1,
    :scaleScore => 1
    )
 
    student.ext_test_scores.create!(
    :name => "PLAA K Upper Case Letters",
    :date => "2003-04-01",
    :result => 2
    )


    date="2003-09-26"
    grade = 1

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Editing Skills",
    :date => date,
    :result => 1
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Sounds Rep",
    :date => date,
    :result => 1
    )
    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Spelling",
    :date => date,
    :result => 1
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Text Reading Lvl",
    :date => date,
    :scaleScore => 3
    )

    date="2004-05-26"
    grade = 1

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Editing Skills",
    :date => date,
    :result => 2
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Sounds Rep",
    :date => date,
    :result => 3
    )
    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Spelling",
    :date => date,
    :result => 2
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Text Reading Lvl",
    :date => date,
    :scaleScore => 14
    )
 
 
     date="2004-10-18"
    grade = 2 

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Editing Skills",
    :date => date,
    :result => 2
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Sounds Rep",
    :date => date,
    :result => 2
    )
    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Spelling",
    :date => date,
    :result => 2
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Text Reading Lvl",
    :date => date,
    :scaleScore => 14
    )
 

    
   date="2005-05-24"
    grade = 2 

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Editing Skills",
    :date => date,
    :result => 1
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Sounds Rep",
    :date => date,
    :result => 2
    )
    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Spelling",
    :date => date,
    :result => 1
    )

    student.ext_test_scores.create!(
    :name => "PLAA #{grade} Text Reading Lvl",
    :date => date,
    :scaleScore => 23
    )
   ep = ''
   #   student.create_ext_arbitrary(:content => ep)
  
  end

 
end
