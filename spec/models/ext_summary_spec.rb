# == Schema Information
# Schema version: 20101101011500
#
# Table name: ext_summaries
#
#  id                       :integer(4)      not null, primary key
#  student_id               :integer(4)
#  HomeLanguage             :string(255)
#  streetAddress            :string(255)
#  cityStateZip             :string(255)
#  mealstatus               :string(255)
#  englishProficiency       :string(255)
#  specialEdStatus          :string(255)
#  disability1              :string(255)
#  disability2              :string(255)
#  singleParent             :boolean(1)
#  raceEthnicity            :string(255)
#  suspensions_in           :integer(4)
#  suspensions_out          :integer(4)
#  years_in_district        :integer(4)
#  school_changes           :integer(4)
#  years_at_current_school  :integer(4)
#  previous_school_name     :string(255)
#  current_attendance_rate  :float
#  previous_attendance_rate :float
#  esl                      :boolean(1)
#  tardies                  :integer(4)
#  created_at               :datetime
#  updated_at               :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtSummary do
  before(:each) do
    @valid_attributes = {
      :HomeLanguage => "value for HomeLanguage",
      :streetAddress => "value for streetAddress",
      :cityStateZip => "value for cityStateZip",
      :mealstatus => "value for mealstatus",
      :englishProficiency => "value for englishProficiency",
      :specialEdStatus => "value for specialEdStatus",
      :disability1 => "value for disability1",
      :disability2 => "value for disability2",
      :singleParent => false,
      :raceEthnicity => "value for raceEthnicity",
      :suspensions_in => 1,
      :suspensions_out => 1,
      :years_in_district => 1,
      :school_changes => 1,
      :years_at_current_school => 1,
      :previous_school_name => "value for previous_school_name",
      :current_attendance_rate => 1.5,
      :previous_attendance_rate => 1.5,
      :esl => false,
      :tardies => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ExtSummary.create!(@valid_attributes)
  end
end
