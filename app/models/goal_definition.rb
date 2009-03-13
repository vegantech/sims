# == Schema Information
# Schema version: 20090212222347
#
# Table name: goal_definitions
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  district_id :integer
#  position    :integer
#  disabled    :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class GoalDefinition < ActiveRecord::Base
  belongs_to :district
  has_many :objective_definitions, :order =>:position, :dependent => :destroy do
    def build_with_new_asset
      x=build
      x.assets.build
      x
    end
  end
  validates_uniqueness_of :description, :scope=>[:district_id,:description]

  validates_presence_of :title, :description
  acts_as_list :scope=>:district_id

  def disable!
    objective_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end

end
