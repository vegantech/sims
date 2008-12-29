# == Schema Information
# Schema version: 20081227220234
#
# Table name: students
#
#  id          :integer         not null, primary key
#  district_id :integer
#  last_name   :string(255)
#  first_name  :string(255)
#  number      :string(255)
#  id_district :integer
#  id_state    :integer
#  id_country  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  birthdate   :date
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Student do
  before do
    @student = Factory(:student)
  end

  it "should be valid" do 
  end

  describe "principals" do
    it "should show principals from groups and special groups" do
      pending
    end
  end








end
