class CicoPeriod < ActiveRecord::Base
  belongs_to :cico_setting
  validates_presence_of :name
  validates_uniqueness_of :name, :scope=>:cico_setting_id

  def to_s
    name
  end
end
