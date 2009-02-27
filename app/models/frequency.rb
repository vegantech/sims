# == Schema Information
# Schema version: 20090212222347
#
# Table name: frequencies
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Frequency < ActiveRecord::Base
  begin
    FREQUENCIES=Frequency.find(:all)
  rescue
    puts "Error loading frequencies, table may not exist yet."
  end

  def after_create
    Frequency.const_set("FREQUENCIES",Frequency.all)
  end

end
