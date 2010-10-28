# == Schema Information
# Schema version: 20101027022939
#
# Table name: flag_descriptions
#
#  id            :integer(4)      not null, primary key
#  district_id   :integer(4)
#  languagearts  :text
#  math          :text
#  suspension    :text
#  attendance    :text
#  created_at    :datetime
#  updated_at    :datetime
#  gifted        :text
#  science       :text
#  socialstudies :text
#

class FlagDescription < ActiveRecord::Base
  belongs_to :district, :touch => true
  validates_presence_of :district_id
end
