require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# Specs in this file have access to a helper object that includes
# the LoginHelperHelper. For example:
#
# describe LoginHelperHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe LoginHelper do
  describe 'windows_live?' do
    it 'should work' do
      old_const = ::WINDOWS_LIVE_CONFIG if defined? ::WINDOWS_LIVE_CONFIG
      no_live = District.new
      no_live.stub!(:windows_live? => false)
      live = District.new
      live.stub!(:windows_live? => true)

      Object.send :remove_const, "WINDOWS_LIVE_CONFIG" if defined? ::WINDOWS_LIVE_CONFIG
      helper.windows_live?(no_live).should be_false
      helper.windows_live?(live).should be_false

      ::WINDOWS_LIVE_CONFIG=2
      helper.windows_live?(no_live).should be_false
      helper.windows_live?(live).should be_true

      Object.send :remove_const, "WINDOWS_LIVE_CONFIG"

      ::WINDOWS_LIVE_CONFIG = old_const if defined? old_const

    end
  end

  describe "google_apps?" do
    it 'should return true if the district has google_apps enabled' do
      helper.stub!(:current_district => mock_district(:google_apps? => false))
      helper.google_apps?.should be_false
    end
    it 'should return false if the district does not google_apps enabled' do
      helper.stub!(:current_district => mock_district(:google_apps? => true))
      helper.google_apps?.should be_true
    end
  end


  describe "windows_live_icon" do
    it 'should display if windows_live? is true' do
      helper.should_receive(:windows_live?).and_return(true)
      helper.should_receive(:resource_name).and_return(:user)
      helper.windows_live_icon.should == "<a href=\"/users/auth/windowslive\"><img alt=\"Windows Live\" src=\"/assets/WindowsLive-128.png\" title=\"Windows Live\" /></a>"
    end

    it 'should not display if windows_live? is false' do
      helper.should_receive(:windows_live?).and_return(false)
      helper.windows_live_icon.should == nil
    end
  end

  describe "google_apps_icon" do
    it 'should display if google_apps? is true' do
      helper.should_receive(:current_district).and_return(District.new)
      helper.should_receive(:google_apps?).and_return(true)
      helper.should_receive(:resource_name).and_return(:user)
      helper.google_apps_icon.should == "<a href=\"/users/auth/google_apps?domain=\"><img alt=\"Sign in with Gmail/Google Apps\" src=\"/assets/Gmail-128.png\" title=\"Sign in with Gmail/Google Apps\" /></a>"
    end

    it 'should not display if google_apps? is false' do
      helper.should_receive(:google_apps?).and_return(false)
      helper.google_apps_icon.should == nil
    end

  end
end
