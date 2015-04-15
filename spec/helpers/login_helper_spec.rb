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
  def copy_sample_file(name_root="windows_live")
    unless Rails.root.join('config',"#{name_root}.yml").exist?
      FileUtils.cp Rails.root.join('config',"#{name_root}.yml.sample"),
        Rails.root.join('config',"#{name_root}.yml")
    end
  end

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
    it 'should work' do
      old_const = ::GOOGLE_OAUTH_CONFIG if defined? ::GOOGLE_OAUTH_CONFIG
      no_live = District.new
      no_live.stub!(:google_apps? => false)
      live = District.new
      live.stub!(:google_apps? => true)

      Object.send :remove_const, "GOOGLE_OAUTH_CONFIG" if defined? ::GOOGLE_OAUTH_CONFIG
      helper.google_apps?(no_live).should be_false
      helper.google_apps?(live).should be_false

      ::GOOGLE_OAUTH_CONFIG=2
      helper.google_apps?(no_live).should be_false
      helper.google_apps?(live).should be_true

      Object.send :remove_const, "GOOGLE_OAUTH_CONFIG"

      ::GOOGLE_OAUTH_CONFIG = old_const if defined? old_const

    end
  end


  describe "windows_live_icon" do
    it 'should display if windows_live? is true' do
      pending "windows_live omniauth provider not available" unless Devise.omniauth_providers.include? :windowslive
      helper.should_receive(:windows_live?).and_return(true)
      helper.should_receive(:resource_name).and_return(:user)
      helper.windows_live_icon.should == "<a href=\"/users/auth/windowslive\"><img alt=\"Windows Live\" src=\"/assets/WindowsLive-128.png\" title=\"Windows Live\" /></a>"
    end

    it 'should not display if windows_live? is false' do
      helper.should_receive(:windows_live?).and_return(false)
      helper.windows_live_icon.should == nil
    end
  end

  describe "google_apps_link" do
    describe 'when google_apps is enabled' do
      before do
        pending "google_oauth omniauth provider not available" unless Devise.omniauth_providers.include? :google_oauth2
        helper.should_receive(:current_district).twice().and_return(District.new)
        helper.should_receive(:google_apps?).and_return(true)
        helper.should_receive(:resource_name).and_return(:user)
      end

      it 'should display with icon' do
        helper.google_apps_link(:icon => true).should ==
          "<a href=\"http://auth.test.host/users/auth/google_oauth2?hd=&state=\" class=\"google-oauth\"><img alt=\"Sign in with Gmail/Google Apps\" src=\"/assets/Gmail-128.png\" title=\"Sign in with Gmail/Google Apps\" /></a>"
      end

      it 'should display with link' do
        helper.google_apps_link.should ==
          "<a href=\"http://auth.test.host/users/auth/google_oauth2?hd=&state=\" class=\"google-oauth\">Sign in with Gmail/Google Apps</a>"
      end
    end
    describe 'when google_apps is disabled' do
      it 'should not display' do
        helper.should_receive(:google_apps?).and_return(false)
        helper.google_apps_link.should == nil
      end
    end
  end
end
