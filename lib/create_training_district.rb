class CreateTrainingDistrict
  require 'fastercsv'
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
    self.generate_checklist_definition(td)

    Role.find_by_name("regular_user").users << [alphaprin,oneschool]
    Role.find_by_name("school_admin").users << alphaprin
    Role.find_by_name("content_admin").users << content_admin

    self.generate_students(td, alpha_elem, training_homeroom)
    td
    
  end

  def self.generate_interventions(district)
    goalhash = {}
    objectivehash = {}
    clusterhash = {}
    
    tier = district.tiers.create!(:title=>'Test tier')
    
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

    clusterhash.values.each do |ic|
      d = Factory(:intervention_definition, :intervention_cluster_id => ic, :title => "Test #{ic}", :tier => tier)
    end
  end

  def self.generate_checklist_definition(district)
    checklisthash = {}
    questionhash = {}
    elementhash = {}
    
    FasterCSV.table("db/training/checklist_definitions.csv").each do |ck|
      ckhash = ck.to_hash.delete_if{|k,v| v == 0}
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



  
  def self.generate_students(district,school,group)
    first_names = IO.readlines('test/fixtures/common_first_names.txt')
    last_names = IO.readlines('test/fixtures/common_last_names.txt')
    
    1.upto(30) do |i|
      s=Factory(:student, :district => district, :birthdate=>10.years.ago, :first_name => first_names[i-1+ 50*(i %2)], :last_name => "#{i.to_s.rjust(2,'0')}-#{last_names[i-1].capitalize}")
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
  ep = %Q{
<table>
  <tbody><tr><td>Student Address: 123 Training Blvd Apt #{student.first_name[0..1]} Madison, WI 53704</td></tr>
</tbody></table>

<h3>Adult Contacts</h3>
<table>
  <tbody><tr>
  <td>
    <h3>Parent</h3>
  </td>
  <td colspan="5">
    <table>
    <tbody><tr>
      <td>Name</td>
      <td>
      #{student.last_name}, Plato
      </td>
    </tr>

    <tr>
      <td>Address</td>
      <td>123 Training Blvd  Apt #{student.first_name[0..1]}<br>
          Madison, WI 53704
      </td>
    </tr>

      
      
      
      
      
    <tr>
      <td>
        Telephone(s)
      </td>
      <td>(608)555-1212 (CELL) <br>
      </td>
    </tr>
    
    <tr>
      <td>Entitled to Records</td>
      <td>Yes </td>
    </tr>

  </tbody></table>
</td>
</tr>

</tbody></table>


  
  <h3>Siblings</h3>
<table border="1">
  <tbody><tr>
    <th>Name</th>
    <th>Age</th>
    <th>Grade</th>
    <th>StudentNum</th>
  <th>School Name</th>
  </tr>

  <tr>
  <td>
    #{student.last_name}, Brother
  </td>
  <td>12</td>
  <td>07</td>
  <td>123456</td>
  <td>Example Middle</td>
  
</tr>
</tbody></table>

<table>
<tbody><tr><td>Race/Ethnicity: B</td></tr>
  <tr><td>Home Language: English</td></tr>
  <tr><td>Language Proficiency Level: 7</td></tr>
  <tr><td>Receiving ESL services or ESL status:</td><td>No</td></tr>
</tbody></table>
<table>
    <tbody><tr><td>Special Education Status: N</td></tr>
</tbody></table>

<table>
  <tbody><tr><td>Lunch Status: F</td></tr>
    <tr><td>Current Attendance:</td><td>94.14%</td></tr>
  <tr><td>Previous Attendance:</td><td>94.58%</td></tr>
  <tr><td>Suspensions In:   Out: </td></tr>
  <tr><td>Periods Tardy: 3</td></tr>
</tbody></table>
  
<table>
  <tbody><tr><td>Student Mobility: </td>
    <td> Years In District:</td><td>7</td></tr>
  <tr><td></td><td>Years at Current School:</td><td>6</td></tr>
  <tr><td></td><td>Previous School:</td><td>Emerson Elementary</td></tr>
  <tr><td></td><td>School Changes:</td><td>2</td></tr>
</tbody></table>




<h2>Test Scores:</h2>

<h3>Primary Math Assessment</h3>
<table cellpadding="3">

<tbody><tr>


<td rowspan="2">
1
</td>
<td rowspan="2">2001-10-06</td>
</tr>

<tr>
<td></td><td></td>
<td>Total: 3-proficient</td>


</tr>

<td rowspan="2">
2
</td>
<td rowspan="2">2002-10-06</td>
</tr>

<tr>
<td></td><td></td>
<td>Total: 2-basic</td>


</tr>




</tbody></table>

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
 


<h3>Primary Language Arts Assessment</h3>
<table cellpadding="3">

<tbody>


<tr>


<td rowspan="2">
K
</td>
<td rowspan="2">2002-09-01</td>
</tr>

<tr>
<td></td><td></td>
<td>Text Reading Lvl: 1</td>
</tr>
<tr>
<td>Phonemic Awareness: 2-basic </td>
</tr>

<tr>


<td rowspan="2">
K
</td>
<td rowspan="2">2003-04-01</td>
</tr>

<tr>
<td></td><td></td>
<td>Text Reading Lvl: 1</td>
</tr>
<tr>
<td> Phonemic Awareness: 3-proficient </td>
</tr>
<tr>
<td> Concepts about Print: 3-proficient </td>
</tr>
<tr>
<td> Hearing Sounds in Words: 1-minimal </td>
</tr>
<tr>
<td>Lower Case Letters: 2-basic  </td>
</tr>
<tr>
<td>Sound Word: 2-basic </td>
</tr>
<tr>
<td>Upper Case Letters: 2-basic  </td>
</tr>




<tr>




<td rowspan="2">
3
</td>
<td rowspan="2">0005-10-06</td>
</tr>

<tr>
<td></td><td></td>
<td>Text Reading Lvl: 14</td>


</tr>


</tbody></table>

<h3>WKCE</h3>
<table cellpadding="3">

<tbody><tr>


<td rowspan="2">
Grade 4
</td>
</tr>

<tr>
<td></td><td></td>
<td>Language arts: 3-proficient</td>
<td>Math: 2-basic</td>
</tr>
<tr>
<td>Science: 3-proficient</td>
<td>Social Studies: 4-advanced</td>
</tr>
<tr>
<td>Reading: 3-proficient</td>
</tr>


<tr>


<td rowspan="4">
3
</td>
</tr>

<tr>
<td></td><td></td>
<td>Math: 3-proficient</td>
<td>Reading: 3-proficient</td>


</tr>

</tbody></table>

}


  ep2= '<pre>
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


 </pre>'

  
  File.open("tmp/ext_p","w"){|f| f << ep}
  
  student.extended_profile = File.open("tmp/ext_p","r")
  student.save
  end

 
end
