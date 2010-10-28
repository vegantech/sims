# == Schema Information
# Schema version: 20101027022939
#
# Table name: consultation_forms
#
#  id                   :integer(4)      not null, primary key
#  user_id              :integer(4)
#  team_consultation_id :integer(4)
#  do_differently       :text
#  parent_notified      :text
#  not_in_sims          :text
#  desired_outcome      :text
#  created_at           :datetime
#  updated_at           :datetime
#  student_id           :integer(4)
#  race_culture         :text
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationForm do
  before(:each) do
    @valid_attributes = {
      :do_differently => "value for do_differently",
      :parent_notified => "value for parent_notified",
      :not_in_sims => "value for not_in_sims",
      :desired_outcome => "value for desired_outcome",
    }
  end

  it "should create a new instance given valid attributes" do
    ConsultationForm.create!(@valid_attributes)
  end
end
