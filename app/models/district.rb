# == Schema Information
# Schema version: 20101101011500
#
# Table name: districts
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(255)
#  abbrev                :string(255)
#  state_dpi_num         :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#  admin                 :boolean(1)
#  logo_file_name        :string(255)
#  logo_content_type     :string(255)
#  logo_file_size        :integer(4)
#  logo_updated_at       :datetime
#  marked_state_goal_ids :string(255)
#  key                   :string(255)     default("")
#  previous_key          :string(255)     default("")
#  lock_tier             :boolean(1)
#  restrict_free_lunch   :boolean(1)      default(TRUE)
#

class District < ActiveRecord::Base
#  ActiveSupport::Dependencies.load_missing_constant self, :StudentsController
  LOGO_SIZE = "200x40"
  include LinkAndAttachmentAssets
  has_many :users, :order => :username
  has_many :checklist_definitions, :inverse_of => :district
  has_many :flag_categories
  has_many :core_practice_assets, :through => :flag_categories, :source=>"assets"
  has_many :recommendation_definitions
  has_many :goal_definitions, :order=>'position'
  has_many :objective_definitions, :through => :goal_definitions
  has_many :probe_definitions
  has_many :quicklist_items, :dependent=>:destroy
  has_many :quicklist_interventions, :class_name=>"InterventionDefinition", :through => :quicklist_items, :source=>"intervention_definition"
  has_many :recommended_monitors, :through => :probe_definitions
  has_many :tiers, :order => 'position', :dependent => :delete_all
  has_many :schools, :order => :name
  has_many :enrollments, :through => :schools
  has_many :students
  has_many :special_user_groups
  has_many :news,:class_name=>"NewsItem"
  has_many :principal_override_reasons
  has_many :logs, :class_name => "DistrictLog", :order => "created_at DESC"
  has_many :flag_descriptions
  has_many :staff_assignments,:through => :schools


  has_attached_file  :logo


  scope :normal, where(:admin=>false).order('name')
  scope :admin, where(:admin=>true)
  scope :in_use,  where("users.username != 'district_admin' and users.id is not null").includes(:users)

  define_statistic :districts_with_at_least_one_user_account , :count => :in_use



  validates_presence_of :abbrev,:name
  validates_uniqueness_of :abbrev,:name
  validates_uniqueness_of :admin,  :if=>lambda{|d| d.admin?}  #only 1 admin district
  validates_format_of :abbrev, :with => /\A[0-9a-z]+\Z/i, :message => "Can only contain letters or numbers"
  validates_exclusion_of :abbrev, :in => System::RESERVED_SUBDOMAINS
  validate  :check_keys, :on => :update
  before_destroy :make_sure_there_are_no_schools
  after_destroy {|d| ::CreateInterventionPdfs.destroy(d) }
  before_validation :clear_logo
  after_create :create_admin_user
  before_update :backup_key



  GRADES=  %w{ PK KG 01 02 03 04 05 06 07 08 09 10 11 12}

  def grades
    GRADES
  end

  def active_checklist_document
    active_checklist_definition.try(:document)
  end

  def active_checklist_document?
    active_checklist_definition.try(:document?)
  end

  def active_checklist_definition
    checklist_definitions.find_by_active(true)
  end




  def find_intervention_definition_by_id(id)
    InterventionDefinition.find(id,:include=>{:intervention_cluster=>{:objective_definition=>:goal_definition}}, :conditions=>{'goal_definitions.district_id'=>self.id})
  end

  def search_intervention_by
    #FIXME some districts may not use goals or objectives
    #so they should be able to choose which to search by on the
    #student search screen
    objective_definitions
  end

  def administers
    if system_admin?
      System
    else
      self
    end
  end


  def system_admin?
    admin?
  end

  def to_s
    self.name
  end

  def reset_admin_password!
    u=users.find_by_username("district_admin")
    if u
      u.reset_password!
    else
      "Could not find user, try recreating the admin user"
    end
  end

  def recreate_admin!
    u=users.find_by_username('district_admin')
    u.destroy if u
    create_admin_user
    'district_admin recreated'
  end

  def delete_logo=(value)
    @delete_logo = !value.to_i.zero?
  end

  def delete_logo
    !!@delete_logo
  end

  def state_district
    @state2||=admin_district
  end

  def intervention_clusters
    @intervention_clusters ||= InterventionCluster.scoped :joins => {:objective_definition=>:goal_definition},
      :conditions => {:goal_definitions =>{:district_id => self.id}}
  end

  def intervention_definitions
    @intervention_definitions ||= InterventionDefinition.scoped :joins => {:intervention_cluster => {:objective_definition=>:goal_definition}},
      :conditions => {:goal_definitions =>{:district_id => self.id}}
  end


  def find_probe_definition(p_id)
    probe_definitions.find_by_id(p_id)
  end


  def admin_district
    District.admin.first
  end

  def self.madison
    find_by_abbrev('madison')
  end

  def url(path='')
    if defined? SIMS_DOMAIN
      host=SIMS_DOMAIN
    else
      host="localhost"
    end

    "#{SIMS_PROTO}://#{host}/#{path}?abbrev=#{abbrev}"

  end

  def touch
    #I don't want validations to run, but I need to fix locking here!!!
    begin
    self.class.update_all( "updated_at = '#{Time.now.utc.to_s(:db)}'", "id = #{self.id}")
    rescue ActiveRecord::StatementInvalid
      logger.warn "Unable to get lock for touch in district!"
    end
  end

  def show_aim_line?
    Rails.env.wip? || Rails.env.development?  || ['madison'].include?(self.abbrev)
  end

  def show_personal_groups?
    Rails.env.wip? || Rails.env.development? || ['madison','mmsd','ripon','maps','rhinelander'].include?(self.abbrev)
  end

  def show_team_consultation_attachments?
    #Remove all references to this when put into production
    Rails.env.wip? || Rails.env.development?  ||  ['grafton','madison','mmsd', 'rhinelander','ripon'].include?(self.abbrev)
  end


  def claim(student)
    res=false
    msg = nil
    if VerifyStudentInDistrictExternally.enabled?
      begin
        res=VerifyStudentInDistrictExternally.verify(student.id_state,state_dpi_num)
      rescue StudentVerificationError => e
        logger.info "Student verification error e.inspect"
        msg='Error verifiying student location'
      end
    else
      res = student.district.blank?
    end

    if res
      student.update_attribute(:district_id,id)
      msg= "Student #{student.to_s} has been added to your district"
    else
      msg ||= "Student #{student.to_s} could not be claimed, student may belong to another district"
    end
    return res,msg
  end

private

  def make_sure_there_are_no_schools
    if schools.blank?
      schools.destroy_all
      users.destroy_all
      checklist_definitions.destroy_all
      goal_definitions.destroy_all
      probe_definitions.destroy_all
      tiers.destroy_all
      students.destroy_all
      special_user_groups.destroy_all
      news.destroy_all
    else
      errors.add(:base, "Have the district admin remove the schools first.")
      false
    end
  end


  def create_admin_user
    if users.blank?
      u=users.build(:username=>"district_admin", :first_name=>name, :last_name => "Administrator")
      u.roles='local_system_administrator'
      u.reset_password!
      u.save!
    end
  end

  def clear_logo
    self.logo=nil if @delete_logo && !logo.dirty?
  end

  def check_keys
    if key_changed? and key.present? and previous_key.present?
      errors.add(:key, "Please contact the system administrator if you need to change your district key again.
      The district key is a part of the password hash generated for each user.
      Changing it (again) could prevent any user in your district from accessing SIMS, as the key used to generate the hash may not match what is in SIMS.")

      false
    end
  end

  def backup_key
    self.previous_key = key_was if key_changed? and key.present?
  end
end

