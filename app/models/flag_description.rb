class FlagDescription < ActiveRecord::Base
  belongs_to :district, :touch => true
  validates_presence_of :district_id
end
