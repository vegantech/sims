# == Schema Information
# Schema version: 20090524185436
#
# Table name: consultation_form_concerns
#
#  id                   :integer         not null, primary key
#  area                 :integer
#  consultation_form_id :integer
#  checked              :boolean
#  strengths            :text
#  concerns             :text
#  recent_changes       :text
#  created_at           :datetime
#  updated_at           :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormConcern do
  before(:each) do
    @valid_attributes = {
      :area => 1,
      :strengths => "value for strengths",
      :concerns => "value for concerns",
      :recent_changes => "value for recent_changes"
    }
  end

  it "should create a new instance given valid attributes" do
    ConsultationFormConcern.create!(@valid_attributes)
  end
end
