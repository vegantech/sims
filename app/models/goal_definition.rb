# == Schema Information
# Schema version: 20101101011500
#
# Table name: goal_definitions
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  district_id :integer(4)
#  position    :integer(4)
#  disabled    :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#

class GoalDefinition < ActiveRecord::Base
  belongs_to :district
  attr_protected :district_id
  has_many :objective_definitions, :order =>:position, :dependent => :destroy do
    def build_with_new_asset
      x=build
      x.assets.build
      x
    end
  end
  validates_uniqueness_of :description, :scope=>[:district_id,:title]

  validates_presence_of :title, :description
  acts_as_list :scope=>:district_id



  define_statistic :count , :count => :all
  define_statistic :distinct_titles , :count => :all,  :select => 'distinct title'
  define_calculated_statistic :districts_with_changes do
    find(:all,:group => 'title', :having => 'count(title)=1',:select =>'distinct district_id').length
  end



  def disable!
    objective_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end

end
