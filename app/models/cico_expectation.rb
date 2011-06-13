class CicoExpectation < ActiveRecord::Base
  belongs_to :cico_setting

  validates_presence_of :name

  def to_s
    name
  end
end
