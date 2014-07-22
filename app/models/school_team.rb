# == Schema Information
# Schema version: 20101101011500
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
  include LinkAndAttachmentAssets

  belongs_to :school
  has_many :school_team_memberships
  has_many :users, through: :school_team_memberships
  has_many :team_contacts, through: :school_team_memberships, source: :user,conditions: ["school_team_memberships.contact =?", true]
  has_many :team_consultations

  DESCRIPTION="Used to set up teams to be used to identify the potential team recipients of the Team Consultation Form."

  scope :named, where(anonymous: false).order('name')
  scope :district, joins(:school).merge(School.district)
  validates_presence_of :name, unless: :anonymous?
  validates_presence_of :contact_ids, unless: :anonymous?, message: 'There must be at least one contact'
  after_save :update_contacts

  alias_method  :original_user_ids=, :user_ids=

  def contact_ids=(ids)
    @contact_ids=ids.select(&:present?).collect(&:to_i)
  end

  def contact_ids
    @contact_ids || self.team_contact_ids
  end

  def user_ids=(ids)
    @member_ids = ids
  end

  def to_s
    name
  end

  private
  def update_contacts
    @member_ids ||= user_ids
    @member_ids |= @contact_ids if @contact_ids
    self.original_user_ids = @member_ids
    if @contact_ids
      # demote former contacts that are now members
      school_team_memberships.where(["user_id not in (?)", @contact_ids]).update_all(contact: false)
      # remove contacts that are no longer members
      school_team_memberships.where(contact: true).where(["user_id not in (?)", @member_ids]).delete_all
      # promote new contacts
      school_team_memberships.where(user_id: @contact_ids).update_all(contact: true)
    end
  end
end
