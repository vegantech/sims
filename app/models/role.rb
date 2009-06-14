# == Schema Information
# Schema version: 20090524185436
#
# Table name: roles
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  district_id        :integer
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime
#

class Role < ActiveRecord::Base

  SYSTEM_ROLES ={
                  "district_admin" => 'Add a logo, set the district key, add users, add schools, 
                  assign roles, add students, enroll students, import files, set district abbreviation',
                  "school_admin" => 'Create groups, assign students and groups, maintain quicklist', 
                  "district_builder" => 'Setup Goals, Objectives, Categories, Interventions, Tiers, Checklists, and Progress Monitors', 
                  "regular_user" => 'Regular user of SIMS', 
                  "news_admin"  => 'Create and edit news items that appear on the left' , 
                  "state_admin" => 'Creates and edits states',
                  "country_admin" => 'Creates and edits countries'
                }
  include LinkAndAttachmentAssets

  belongs_to :district
  has_many :rights, :dependent=>:destroy
  has_and_belongs_to_many :users

  acts_as_list # :scope =>[:district_id,:state_id, :country_id, :system]  need to fix this
  named_scope :system, :conditions => {:district_id => nil}


  def self.has_controller_and_action_group?(controller,action_group)
    return false unless %w{ read_access write_access }.include?(action_group)
    find(:all).any?{|r| r.rights.find_by_controller(controller,:conditions=>["#{action_group}=?",true])}
  end

  def to_s
    if system?  
      "<b>#{name}</b>"
    else
      name
    end
  end

  def system?
    district_id.blank?
  end

  private

  def after_initialize
      puts "In after initialize"
    unless rights.any?
      self.rights.build(:controller=>"students")
    end

  end

end
