# == Schema Information
# Schema version: 20101027022939
#
# Table name: probe_questions
#
#  id                  :integer(4)      not null, primary key
#  probe_definition_id :integer(4)
#  number              :integer(4)
#  operator            :string(255)
#  first_digit         :integer(4)
#  second_digit        :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeQuestion do
  before(:each) do
    @valid_attributes = {
      :number => "1",
      :operator => "value for operator",
      :first_digit => "1",
      :second_digit => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProbeQuestion.create!(@valid_attributes)
  end
end
