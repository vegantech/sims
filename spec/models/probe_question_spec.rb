# == Schema Information
# Schema version: 20090325230037
#
# Table name: probe_questions
#
#  id                  :integer         not null, primary key
#  probe_definition_id :integer
#  number              :integer
#  operator            :string(255)
#  first_digit         :integer
#  second_digit        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  copied_at           :datetime
#  copied_from         :integer
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
