# == Schema Information
# Schema version: 20090212222347
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  district_id :integer
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Role < ActiveRecord::Base
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
