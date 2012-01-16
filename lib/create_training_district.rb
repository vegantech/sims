class CreateTrainingDistrict
  require 'fastercsv'
  def self.generate
    generate_one
    2.upto(20){ |i| generate_one(i.to_s)}
    generate_named_districts
    unless Rails.env.production?
      InterventionDefinition.update_all("sld ='Mathematics problem solving', mins_per_week=30","title = 'Make the Verb Active '")
      InterventionDefinition.find_all_by_title('Make the Verb Active ').each{|idd| idd.district.schools.first.quicklist_interventions << idd.intervention_cluster.intervention_definitions}
    end

    setup_sci_demo_content District.find_by_abbrev('training20')
    setup_staff_assignment_demo_content District.find_by_abbrev('training20')
  end

  def self.generate_named_districts
    Dir.glob(File.join(Rails.root,"public","system", "district_demo_content","*")).each {|d| generate_named_district d}
  end

  def self.generate_named_district district_dir
    abbrev=File.basename(district_dir)
    name = "z #{abbrev} Content"
    destroy_district abbrev
    td = create_with_schools_and_users(abbrev,name)
    self.generate_interventions(td, district_dir)
    self.generate_checklist_definition(td)
    td.news.create(:text=>"Content as of %s" % File.mtime(district_dir).to_s(:short))
  end


  def self.destroy_district abbrev
    d=District.find_by_abbrev(abbrev)
     if d.present?
      d.schools.destroy_all
      d.tiers.delete_all
      d.flag_categories.destroy_all
      d.destroy
    end
  end

  def self.create_with_schools_and_users(abbrev,name)
    td=District.create!(:abbrev=>abbrev, :name =>name)
    #alpha elementary
    alpha_elem=td.schools.create!(:name => 'Alpha Elementary')

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
    training_team = alpha_elem.school_teams.create!(:name => "Training", :contact_ids => [oneschool.id])

    #oneschool
    #alphaprin
    #students

    alphaprin = td.users.create!(:username => 'alphaprin', :password => 'alphaprin', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Principal')
    alphaprin.user_school_assignments.create!(:admin => true, :school => alpha_elem)
    alphaprin.special_user_groups.create!(:school=>alpha_elem, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :is_principal => true, :district => td)

    training_team.school_team_memberships.create!(:user => alphaprin, :contact => false)

    content_admin = td.users.create!(:username => 'content_builder', :password => 'content_builder', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Content Admin')

    other_team = alpha_elem.school_teams.create!(:name => "Other Team", :contact_ids => [alphaprin.id])
    td.flag_categories.create!({"category"=>"math", "threshold"=>"30", "existing_asset_attributes"=>{"qqq"=>""}, "new_asset_attributes"=>[{"name"=>"Math Core Practices (Madison)", "url"=>"/file/Mathematics_Core_Practices.pdf"}]})

    Role.add_users "regular_user", [alphaprin,oneschool]
    Role.add_users "school_admin", alphaprin
    Role.add_users "content_admin",  content_admin

    self.generate_students(td, alpha_elem, training_homeroom)
    self.generate_other_students(td,alpha_elem, other_homeroom)

    td
  end

  def self.generate_one(num = '')

    abbrev = "training#{num}"
    name = abbrev.capitalize
    destroy_district abbrev
    td=create_with_schools_and_users(abbrev,name)


    self.generate_interventions(td)
    self.generate_checklist_definition(td)
    td.news.create(:text=>"District Reset %s" % Time.now.to_s(:short))

   td

  end

  def self.generate_interventions(district,path="db/training")
    goalhash = {}
    objectivehash = {}
    clusterhash = {}
    definitionhash = {}
    probe_hash = {}

    if File.exist?(File.join(path,"tiers.csv"))
      oldtiers =
      tier_csv=FasterCSV.table("#{path}/tiers.csv").sort_by{|e| e[:position]}
      oldtiers=tier_csv.collect{|t| t[:id]}
      tiers=[]
      tier_csv.each do |ck|
        ckhash = ck.to_hash.delete_if{|k,v| v == 0}
        tiers <<  district.tiers.create!(ckhash)
      end

    else
      oldtiers=[781074649, 781074650, 781074651]
      tier = district.tiers.create!(:title=>'First tier')
      second_tier = district.tiers.create!(:title=>'Second tier')
      third_tier = district.tiers.create!(:title=>'Third tier')
      tiers = [tier,second_tier,third_tier]
    end


    FasterCSV.table("#{path}/goal_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      next if ck.to_hash[:deleted_at].to_i !=0
      newcd= district.goal_definitions.create!(ckhash)
      goalhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("#{path}/objective_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:goal_definition_id]= goalhash[ck[:goal_definition_id]]
      newcd= ObjectiveDefinition.create!(ckhash)
      objectivehash[ck[:id]]=newcd.id
    end

    FasterCSV.table("#{path}/intervention_clusters.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:objective_definition_id]= objectivehash[ck[:objective_definition_id]]
      newcd= InterventionCluster.create!(ckhash)
      clusterhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("#{path}/intervention_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:intervention_cluster_id]= clusterhash[ck[:intervention_cluster_id]]
      mytier = tiers.collect(&:id)[oldtiers.index(ck[:tier_id].to_i)] || tier
      unless ckhash[:disabled] or ckhash[:custom]
        ckhash[:notify_email] = nil
        newcd= InterventionDefinition.create!(ckhash.merge(:tier_id => mytier))
        definitionhash[ck[:id]]=newcd.id
      end
    end



    if File.exist?("#{path}/probe_definitions_monitors.csv")
      pdf="#{path}/probe_definitions_monitors.csv"
    else
      pdf = "#{path}/probe_definitions.csv"
    end

    FasterCSV.table(pdf).each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      if ckhash[:active] and !ckhash[:custom]
        newcd= district.probe_definitions.create!(ckhash)
        probe_hash[ck[:id]]=newcd.id
      end
    end

    FasterCSV.table("#{path}/recommended_monitors.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:intervention_definition_id]= definitionhash[ck[:intervention_definition_id]]
      ckhash[:probe_definition_id]= probe_hash[ck[:probe_definition_id]]
      newcd= RecommendedMonitor.new(ckhash)
      newcd.save! if newcd.probe_definition && newcd.intervention_definition
    end

    FasterCSV.table("#{path}/probe_definition_benchmarks.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0 || k.to_s == "deleted_at"}
      ckhash[:probe_definition_id]= probe_hash[ck[:probe_definition_id]]

      newcd= ProbeDefinitionBenchmark.new(ckhash)
      newcd.save! if newcd.valid?
    end



    FasterCSV.table("#{path}/assets.csv").each do |ck|

      old_id = ck[:attachable_id]
      case ck[:attachable_type]
      when 'ProbeDefinition'
        newid=probe_hash[old_id]
      when 'InterventionDefinition'
        newid = definitionhash[old_id]
      else
        newid = nil
      end

      generate_assets_from_row(newid, ck) if newid.present?


    end
  end

  def self.generate_assets_from_row(attachable_id, row)
    generate_asset_from_name_and_url(attachable_id, row) if row[:url].present? && row[:url].to_s !="0"
    generate_asset_from_file(attachable_id,row) if row[:document_file_name].present? && row[:document_file_name].to_s != "0"
  end

  def self.generate_asset_from_name_and_url(attachable_id, row)
    if row[:url].to_s.include?("/")
      url = row[:url]
    else
      url = "/file/#{row[:url]}"
    end

    raise row.inspect if url == "/file/0"
    Asset.create!(:attachable_type => row[:attachable_type], :attachable_id => attachable_id, :url => url, :name => row[:name])
  end

  def self.generate_asset_from_file(attachable_id, row)
    filename = row[:document_file_name]
    Asset.create!(:attachable_type => row[:attachable_type], :attachable_id => attachable_id, :url => "/file/#{filename}", :name => filename)
  end

  def self.generate_checklist_definition(district, path="db/training")
    checklisthash = {}
    questionhash = {}
    elementhash = {}

    FasterCSV.table("#{path}/checklist_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:active]=!!district.abbrev.match(/^training/) || district.abbrev =='madison'

      newcd= district.checklist_definitions.create!(ckhash)
      checklisthash[ck[:id]]=newcd.id
    end

    FasterCSV.table("#{path}/question_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:checklist_definition_id]= checklisthash[ck[:checklist_definition_id]]
      newcd= QuestionDefinition.create!(ckhash)
      questionhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("#{path}/element_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
      ckhash[:question_definition_id]= questionhash[ck[:question_definition_id]]
      newcd= ElementDefinition.create!(ckhash)
      elementhash[ck[:id]]=newcd.id
    end

    FasterCSV.table("#{path}/answer_definitions.csv").each do |ck|
      next if ck.to_hash[:deleted_at].to_i !=0
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


  def self.setup_sci_demo_content(district)   #cico
    d=district
    pd=d.probe_definitions.create!(:title => 'SCI', :description => 'Student Check-In', :cico => true, :minimum_score => 0, :maximum_score => 100)
    ic= d.intervention_clusters.find_by_title('Behavior Management')
    id=ic.intervention_definitions.build(:title => 'SCI', :description => 'Student Check-In', :tier => d.tiers[1], :frequency=>Frequency.first,:time_length =>TimeLength.first )
    id.probe_definitions << pd
    id.save!


    d.schools.each do |sch|
      cico_setting = sch.cico_settings.create!(:enabled => true, :probe_definition => pd)
      cico_setting.cico_expectations.create!(:name => 'Respect')
      cico_setting.cico_expectations.create!(:name => 'Attendance')
      cico_setting.cico_expectations.create!(:name => 'Participation')
      1.upto(5){|p| cico_setting.cico_periods.create!(:name => "Period #{p}")}
    end

    #setup interventions  with start dates in the past


    user= d.users.find_by_username 'oneschool'
    other_user = d.users.find_by_username 'alphaprin'
    other_user_ids = other_user.id
    school = d.schools.first
    selected_students = school.students.sort_by{rand}[0..15]
    selected_ids = selected_students.collect(&:id)[1..-1]
    current_student = selected_students.first
    values_from_session = {:school_id => school.id, :selected_ids => selected_ids, :user_id => user.id}

=begin
    {"commit"=>"Save", "action"=>"create", "authenticity_token"=>"Xno6TQCrmoHpkSNZ+lLRjUWKuTfjkqChgJ6YHlMPIxY=",
      "intervention"=>{"end_date(3i)"=>"25", "start_date(1i)"=>"2011", "apply_to_all"=>"1", "start_date(2i)"=>"9", "auto_implementer"=>"1",
        "intervention_probe_assignment"=>{"end_date(3i)"=>"25", "goal"=>"", "probe_definition_id"=>"98",
          "frequency_multiplier"=>"2", "first_date(1i)"=>"2011", "first_date(2i)"=>"9", "frequency_id"=>"284292352",
          "first_date(3i)"=>"25", "end_date(1i)"=>"2011", "end_date(2i)"=>"10"}, "start_date(3i)"=>"25",
          "frequency_multiplier"=>"1", "participant_user_ids"=>["18"], "time_length_id"=>"785548667",
          "frequency_id"=>"529071850", "intervention_definition_id"=>"184", "comment"=>{"comment"=>""},
          "end_date(1i)"=>"2011", "time_length_number"=>"1", "end_date(2i)"=>"10"}, "controller"=>"interventions"}
=end
    start_date = Date.today - 2.weeks
    end_date = Date.today + 2.weeks
    params = {
        :end_date => end_date, :start_date => start_date, :apply_to_all => "1", :auto_implementer => "1",
        :frequency_multiplier => "1", :participant_user_ids => [other_user_ids], :time_length => id.time_length,
        :frequency => id.frequency, :intervention_definition_id => id.id, :time_length_number => '1',
        :intervention_probe_assignment => {
          :end_date => end_date, :first_date => start_date, :probe_definition_id => pd.id, :frequency_multiplier => 2,
          :frequency => id.frequency}
    }


    @intervention = current_student.interventions.build_and_initialize(params.merge(values_from_session))
    @intervention.save
    #assign content for previous week



  end

  def self.setup_staff_assignment_demo_content(district)
    district.schools.each do |sch|
      sch.user_school_assignments.each do |usa|
        sch.staff_assignments.create(:user_id => usa.user_id)
      end
    end

    district.schools.create!(:name => 'Beta Elementary')

  end

end
