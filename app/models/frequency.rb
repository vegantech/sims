# == Schema Information
# Schema version: 20090623023153
#
# Table name: frequencies
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Frequency < ActiveRecord::Base
  #TODO ADD POSITION
  @all_cache_order = "id"
  include AllCache
end

