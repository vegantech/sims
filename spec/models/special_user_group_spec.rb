# == Schema Information
# Schema version: 20101101011500
#
# Table name: special_user_groups
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  district_id  :integer(4)
#  school_id    :integer(4)
#  grouptype    :integer(4)
#  grade        :string(255)
#  is_principal :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SpecialUserGroup do
end
