class FlagDescription < ActiveRecord::Base
  belongs_to :district
  validates_presence_of :district_id
end
