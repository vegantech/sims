# == Schema Information
# Schema version: 20101101011500
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
  acts_as_reportable

  def to_s
    title
  end
end

