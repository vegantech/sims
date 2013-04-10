class CreateTrainingDistrict
  require 'csv'
  def self.generate
      generate_one
      2.upto(20){ |i| generate_one(i.to_s)}
      generate_named_districts
  end

  def self.generate_named_districts
    Dir.glob(File.join(Rails.root,"public","system", "district_demo_content","*")).each {|d| generate_named_district d}
  end

  def self.generate_named_district district_dir
    abbrev=File.basename(district_dir)
    name = "z #{abbrev} Content"
    destroy_district abbrev
    td = create_with_schools_and_users(abbrev,name)
    TrainingDistrict::Content.generate_interventions(td, district_dir)
    TrainingDistrict::Content.generate_checklist_definition(td)
    td.news.create(:text=>"Content as of %s" % File.mtime(district_dir).to_s(:short))
  end


  def self.destroy_district abbrev
    d=District.find_by_abbrev(abbrev)
     if d.present?
      d.schools.destroy_all
      d.tiers.delete_all
      d.flag_categories.destroy_all
      FileUtils.rm(Dir.glob(Rails.root.join("public","system","district_generated_docs",d.id.to_s,"*")))
      d.destroy
    end
  end

  def self.create_with_schools_and_users(abbrev,name)
    td=District.create!(:abbrev=>abbrev, :name =>name, :forgot_password => true)
    ActiveRecord::Base.transaction do
    td.send :create_admin_user
    #alpha elementary
    alpha_elem=td.schools.create!(:name => 'Alpha Elementary')

    oneschool = td.users.create!(:username => 'oneschool', :password => 'oneschool', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'User')

    melody = td.users.create!(:username => 'melody', :password => 'melody', :email => 'shawn@simspilot.org', :first_name => 'Melody', :last_name => 'TrebleCleff')

    training_homeroom = alpha_elem.groups.create!(:title => "Training Homeroom")
    other_homeroom = alpha_elem.groups.create!(:title => 'Other Group')
    oneschool.groups << training_homeroom
    oneschool.groups << other_homeroom

    melody.groups << other_homeroom
    melody.user_school_assignments.create!(:school => alpha_elem)
    oneschool.user_school_assignments.create!(:school => alpha_elem)



    oneschool.save!
    melody.save!
    training_team = alpha_elem.school_teams.create!(:name => "Training", :contact_ids => [oneschool.id])

    #oneschool
    #alphaprin
    #students

    alphaprin = td.users.create!(:username => 'alphaprin', :password => 'alphaprin', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Principal')
    alphaprin.user_school_assignments.create!(:admin => true, :school => alpha_elem)
    alphaprin.special_user_groups.create!(:school=>alpha_elem, :is_principal => true)

    training_team.school_team_memberships.create!(:user => alphaprin, :contact => false)

    content_admin = td.users.create!(:username => 'content_builder', :password => 'content_builder', :email => 'shawn@simspilot.org', :first_name => 'Training', :last_name => 'Content Admin')

    other_team = alpha_elem.school_teams.create!(:name => "Other Team", :contact_ids => [alphaprin.id])
    td.flag_categories.create!({"category"=>"math", "threshold"=>"30", "existing_asset_attributes"=>{"qqq"=>""}, "new_asset_attributes"=>[{"name"=>"Math Core Practices (Madison)", "url"=>"/file/Mathematics_Core_Practices.pdf"}]})

    Role.add_users "regular_user", [alphaprin,oneschool]
    Role.add_users "school_admin", alphaprin
    Role.add_users "content_admin",  content_admin

    TrainingDistrict::Student.generate_students(td, alpha_elem, training_homeroom)
    TrainingDistrict::Student.generate_other_students(td,alpha_elem, other_homeroom)
    end

    td
  end

  def self.generate_one(num = '')

    abbrev = "training#{num}"
    name = abbrev.capitalize
    destroy_district abbrev
    td=create_with_schools_and_users(abbrev,name)

    ActiveRecord::Base.transaction do
      TrainingDistrict::Content.generate_interventions(td)
      TrainingDistrict::Content.generate_checklist_definition(td)
    end
    td.news.create(:text=>"District Reset %s" % Time.now.to_s(:short))
   td
  end

end
