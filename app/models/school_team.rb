# == Schema Information
# Schema version: 20101027022939
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
  has_many :team_contacts, :through =>:school_team_memberships, :source=>:user,:conditions => ["school_team_memberships.contact =?", true]
  has_many :team_consultations

  named_scope :named, {:conditions => {:anonymous => false }, :order => 'name'}
  validates_presence_of :name, :unless => :anonymous?
  validates_presence_of :contact_ids, :unless => :anonymous?, :message =>'There must be at least one contact'
  after_save :update_contacts

  def contact_ids=(ids)
    @contact_ids=ids.collect(&:to_i)
  end

  def contact_ids
    @contact_ids || self.team_contact_ids
  end

  def to_s
    name
  end

  private
  def update_contacts
    if @contact_ids
      self.user_ids |=@contact_ids
      SchoolTeamMembership.delete_all("contact=true and user_id not in (#{@contact_ids.join(",")}) and school_team_id = #{self.id}")
      school_team_memberships.update_all('contact=true', "user_id in (#{@contact_ids.join(",")})")
    end
    
  end


end
