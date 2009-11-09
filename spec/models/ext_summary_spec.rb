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
