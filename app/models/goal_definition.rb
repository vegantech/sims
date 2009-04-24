# == Schema Information
# Schema version: 20090325230037
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
#  deleted_at  :datetime
#  copied_at   :datetime
#  copied_from :integer
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
  validates_uniqueness_of :description, :scope=>[:district_id,:title]

  validates_presence_of :title, :description
  acts_as_list :scope=>:district_id
  is_paranoid

  def disable!
    objective_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end

  def deep_clone(district)
    k=district.goal_definitions.find_with_destroyed(:first,:conditions=>{:copied_from=>id, :district_id => district.id}) 
    if k
      #it already exists
   else
      k=clone
      k.district=district
      k.copied_at=Time.now
      k.copied_from = id
      k.save! if k.valid?
    end
     
    k.objective_definitions << objective_definitions.collect{|o| o.deep_clone(k)}
    k
  end

  
  
end
