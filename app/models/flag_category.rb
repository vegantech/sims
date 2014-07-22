# == Schema Information
# Schema version: 20101101011500
#
# Table name: flag_categories
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  threshold   :integer(4)      default(100)
#

class FlagCategory < ActiveRecord::Base
  #Could store icon, threshold for warning, description
  include LinkAndAttachmentAssets  #has many :assets
  belongs_to :district, :touch => true

  validates_uniqueness_of :category, :scope=>:district_id
  validates_inclusion_of :category, :in => Flag::FLAGTYPES.keys
  validates_numericality_of :threshold, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  attr_protected :district_id

  def self.above_threshold(student_ids = [])
    find(:all,
         :select => "flag_categories.id, flag_categories.category, threshold",
         :group => "flags.category",
         :having => "(100 * count(distinct student_id) / #{student_ids.length}) > threshold",
         :joins => "inner join flags on flags.category = flag_categories.category",
         :conditions => ["flags.student_id in (?) and not exists
         (select * from flags as flags2 where flags2.type = 'IgnoreFlag' and flags.category = flags2.category and
         flags.student_id =flags2.student_id) ", student_ids]
        )
  end

end
