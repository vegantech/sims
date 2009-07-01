# == Schema Information
# Schema version: 20090623023153
#
# Table name: school_teams
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  name       :string(255)
#  anonymous  :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class SchoolTeam < ActiveRecord::Base
  belongs_to :school
  has_many :school_team_memberships
  has_many :users, :through => :school_team_memberships
  has_many :team_consultations

  named_scope :named, {:conditions => {:anonymous => false }}
  validates_presence_of :name, :unless => :anonymous?
  after_save :update_contact

  def contact
    c= school_team_memberships.find_by_contact(true)
    if c.present?
      c.user.id
    else
      nil
    end
  end

  def contact=(contact_id)
    @contact = contact_id.to_i
    c=school_team_memberships.find_by_user_id(contact_id) || school_team_memberships.build(:user_id => contact_id)
    c.contact = true
  end

  def to_s
    name
  end

  private
  def update_contact
    if @contact
      school_team_memberships.update_all("contact=false","user_id != #{@contact}")

    end
  end


end
