class CreateTrainingDistrict
  def self.generate
    wi = State.find_by_abbrev('wi')
    d=wi.districts.find_by_abbrev('training')
    if d.present?
      d.schools.destroy_all
      d.destroy
    end
    td=wi.districts.create!(:abbrev=>'training', :name => 'Training')
    #alpha elementary
    alpha_elem=td.schools.create!(:name => 'Alpha Elementry')

    oneschool = td.users.create!(:username => 'oneschool', :password => 'oneschool', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'User')

    training_homeroom = alpha_elem.groups.create!(:title => "Training Homeroom")
    oneschool.groups << training_homeroom
    oneschool.schools << alpha_elem
    oneschool.save!
    
    #oneschool
    #alphaprin
    #students
    
    alphaprin = td.users.create!(:username => 'alphaprin', :password => 'alphaprin', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Principal')
    alphaprin.user_school_assignments.create!(:admin => true, :school => alpha_elem)
    alphaprin.special_user_groups.create!(:school=>alpha_elem, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :is_principal => true)
    content_admin = td.users.create!(:username => 'content_builder', :password => 'content_builder', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Content Admin')

    self.generate_interventions(td)

    Role.find_by_name("regular_user").users << [alphaprin,oneschool]
    Role.find_by_name("school_admin").users << alphaprin
    Role.find_by_name("content_admin").users << content_admin

    self.generate_students(td, alpha_elem, training_homeroom)
    td
    
  end

  def self.generate_interventions(district)
    gd = Factory(:goal_definition, :district => district)
    od = Factory(:objective_definition, :goal_definition => gd)
    ic = Factory(:intervention_cluster, :objective_definition => od)
    id = Factory(:intervention_definition, :intervention_cluster => ic)
  end

  def self.generate_students(district,school,group)
    1.upto(30) do |i|
      s=Factory(:student, :district => district, :birthdate=>10.years.ago, :first_name => "#{i.to_s.rjust(2,'0')}-First", :last_name => "#{i.to_s.rjust(2,'0')}-Last")
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

  ep= '<pre>
  1. Parents contacts, siblings, and emergency contacts-generate
  fake data
  2. Grade-5th grade student
  3. Race/ethnicity: White
  4. Home language: English
  5. Receives ESL services or ESL status: No
  6. Special Education Status: No
  7. Lunch Status: Free
  8. Current attendance: 94.14%
  9. Previous attendance: 94.58%
  10: Suspensions: 0
  11. Student Mobility: Years in District: 7

  Years at Current School: 6 School Changes:2
  12. Tests Scores

  WKCE
  Grade 4: Language arts: 3-proficient Math: 2-basic

  Science: 3-proficient Social Studies: 4-advanced Reading:
  3-proficient
  Grade 3: Math: 3-proficient Reading: 3-proficient

  Primary Math Assessment
  Grade 1: Proficient
  Grade 2: Basic

  Primary Language Arts Assessment
  Kindergarten: 09-01-2002
  Phonemic Awareness: 2-basic Text Reading Lvl: 1

  Kindergarten: 04-01-2003
  Concepts about Print: 3-proficient Hearing Sounds in Words:
  1-minimal
  Lower Case Letters: 2-basic Phonemic Awareness: 3-proficient
  Sound Word: 2-basic Text Reading Lvl: 1
  Upper Case letters: 2-basic

  Grade 1: 9-26-2003
  Editing Skills: 1-minimal Sounds Rep: 1-minimal
  Spelling: 1-minimal Text Reading Lvl: 3

  Grade 1: 5-26-2004
  Editing Skills: 2-basic Sounds Rep: 3-proficient
  Spelling: 2-basic Text Reading Lvl: 14

  Grade 2: 10-18-2004
  Editing Skills: 2-basic Sounds Rep: 2-basic
  Spelling: 2-basic Text Reading Lvl: 14

  Grade 2: 5-24-2005
  Editing Skills: 2-minimal Sounds Rep: 2-basic
  Spelling: 1-minimal Text Reading Lvl: 23
  </pre>'

  
  File.open("tmp/ext_p","w"){|f| f << ep}
  
  student.extended_profile = File.open("tmp/ext_p","r")
  student.save
  end

 
end
