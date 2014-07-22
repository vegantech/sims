# == Schema Information
# Schema version: 20101101011500
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
      do_differently: "value for do_differently",
      parent_notified: "value for parent_notified",
      not_in_sims: "value for not_in_sims",
      desired_outcome: "value for desired_outcome",
    }
  end

  it "should create a new instance given valid attributes" do
    ConsultationForm.create!(@valid_attributes)
  end

  describe "filled_in?" do
    it "should return false when all fields are blank" do
      ConsultationForm.new.filled_in?.should be_false
      ConsultationForm.new(desired_outcome: '').filled_in?.should be_false
    end

    it "should return false when all fields are blank and associated concerns are also blank" do
       cf=ConsultationForm.new
       cf.consultation_form_concerns.build
       cf.filled_in?.should be_false
    end

    it "should return true if all fields are blank but an associated concern is populated" do
       cf=ConsultationForm.new
       cf.consultation_form_concerns.build(strengths: 'true')
       cf.filled_in?.should be_true
    end

    it "should return true if  fields are blank but an associated concern is populated" do
       cf=ConsultationForm.new(race_culture: 'e')
       cf.consultation_form_concerns.build
       cf.filled_in?.should be_true
    end
   end
end
