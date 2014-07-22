class TrainingDistrict::Student
  def self.first_names
    @@first_names ||= IO.readlines('db/training/common_first_names.txt')
  end

  def self.last_names
    @@last_names ||= IO.readlines('db/training/common_last_names.txt')
  end
  def self.generate_other_students(district,school,group)
    grades= ['K', '1', '2', '3', '4', '5']

    31.upto(60) do |i|
      esl=rand(3) == 1
      special_ed = rand(3) == 1
      first_name = first_names[(i%50) -1 + 50*(i %2)].strip
      last_name = last_names[i-1].capitalize.strip
      s=FactoryGirl.create(:student, district: district, birthdate: 10.years.ago, first_name: first_name, last_name: last_name,
                                     number: (i-1).to_s, esl: esl, special_ed: special_ed)
      s.enrollments.create!(school: school, grade: grades[i%6])
      s.groups << group
      s.system_flags.create!(category: "languagearts", reason: "1-edits writing, 1-revises writing, 1-applies
        comprehension strategies to independent reading") if rand(10) == 1
      s.system_flags.create!(category: "math", reason: "1- word problem assessment ") if i.odd?
      s.system_flags.create!(category: "suspension", reason: "2 office referrals") if rand(10) == 1
      s.system_flags.create!(category: "attendance", reason: "3 times tardy ") if rand(10) == 1
    end
  end

  def self.generate_students(district,school,group)
    1.upto(30) do |i|
      s=FactoryGirl.create(:student, district: district, birthdate: 10.years.ago, first_name: first_names[i-1+ 50*(i %2)].strip, last_name: "#{i.to_s.rjust(2,'0')}-#{last_names[i-1].capitalize.strip}",
                                     number: (i-1).to_s)
      s.enrollments.create!(school: school, grade: 5)
      s.groups << group
      s.system_flags.create!(category: "languagearts", reason: "1-edits writing, 1-revises writing, 1-applies
        comprehension strategies to independent reading")
      s.system_flags.create!(category: "math", reason: "1- word problem assessment ") if rand(10) == 1
      s.system_flags.create!(category: "suspension", reason: "2 office referrals") if rand(10) == 1
      s.system_flags.create!(category: "attendance", reason: "3 times tardy ") if rand(10) == 1
      add_extended_profile(s)

    end
  end

  def self.add_extended_profile(student)
    FactoryGirl.create :ext_summary, student: student
    FactoryGirl.create :ext_adult_contact, student: student
    FactoryGirl.create :ext_sibling, student: student
    student.ext_test_scores.create!( [
      {name: "PMA 1 Total", date: "2001-10-06", result: 3},
      {name: "PMA 2 Total", date: "2002-10-06", result: 2},
      {name: "WKCE 4 Language Arts", date: "2004-10-06", result: 3},
      {name: "WKCE 4 Math", date: "2004-10-06", result: 2},
      {name: "WKCE 4 Science", date: "2004-10-06", result: 3},
      {name: "WKCE 4 Social Studies", date: "2004-10-06", result: 4},
      {name: "WKCE 4 Reading", date: "2004-10-06", result: 3},
      {name: "WKCE 3 Math", date: "2003-10-06", result: 3},
      {name: "WKCE 3 Reading", date: "2004-10-06", result: 3},
      {name: "PLAA K Phonemic Awareness", date: "2002-09-01", result: 2},
      {name: "PLAA K Text Reading Level", date: "2002-09-01", result: 2, scaleScore: 1},
      {name: "PLAA K Concepts About Print", date: "2003-04-01", result: 3},
      {name: "PLAA K Hearing Sounds in Words", date: "2003-04-01", result: 1},
      {name: "PLAA K Lower Case Letters", date: "2003-04-01", result: 2},
      {name: "PLAA K Phonemic Awareness", date: "2003-04-01", result: 3},
      {name: "PLAA K Sound Word", date: "2003-04-01", result: 2},
      {name: "PLAA K Text Reading Level", date: "2003-04-01", result: 1, scaleScore: 1},
      {name: "PLAA K Upper Case Letters", date: "2003-04-01", result: 2},
      {name: "PLAA 1 Editing Skills", date: "2003-09-26", result: 1},
      {name: "PLAA 1 Sounds Rep", date: "2003-09-26", result: 1},
      {name: "PLAA 1 Spelling", date: "2003-09-26", result: 1},
      {name: "PLAA 1 Text Reading Lvl", date: "2003-09-26", scaleScore: 3},
      {name: "PLAA 1 Editing Skills", date: "2004-05-26", result: 2},
      {name: "PLAA 1 Sounds Rep", date: "2004-05-26", result: 3},
      {name: "PLAA 1 Spelling", date: "2004-05-26", result: 2},
      {name: "PLAA 1 Text Reading Lvl", date: "2004-05-26", scaleScore: 14},
      {name: "PLAA 2 Editing Skills", date: "2004-10-18", result: 2},
      {name: "PLAA 2 Sounds Rep", date: "2004-10-18", result: 2},
      {name: "PLAA 2 Spelling", date: "2004-10-18", result: 2},
      {name: "PLAA 2 Text Reading Lvl", date: "2004-10-18", scaleScore: 14},
      {name: "PLAA 2 Editing Skills", date: "2005-05-24", result: 1},
      {name: "PLAA 2 Sounds Rep", date: "2005-05-24", result: 2},
      {name: "PLAA 2 Spelling", date: "2005-05-24", result: 1},
      {name: "PLAA 2 Text Reading Lvl", date: "2005-05-24", scaleScore: 23}
    ])
  end
end
