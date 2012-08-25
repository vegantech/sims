require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SessionCheckApp
  include ActionController::UrlFor
  include ActionController::Testing
  include Rails.application.routes.url_helpers
  include ActionController::Compatibility
end

describe SessionCheckApp do
  describe 'index' do
    it 'should respond with the results of check' do
      controller.should_receive(:check).and_return("check chech eck")
      get(:index).body.should == "check chech eck"
    end
  end

  describe 'check' do
    #session
    #params
    #logger?
    subject do
      SessionCheckApp.new.tap do |s|
      s.stub(:params => params)
      s.stub(:session => session)
      end
    end
    let(:session) {{}}
    let(:params) {{}}

    describe 'without user_id in params' do
      its(:check) {""}
    end

    describe 'with a user_id and student in the session' do
      let(:session) {{'selected_student' => 3, 'warden.user.user.key' => ['blah',['1']]}}

      describe 'with matching user id and student in the params' do
        let(:params) {{'current_student_id' => 3, 'user_id' => '1'}}
        its(:check) {""}
      end

      describe 'with mismatching user id' do
        let(:params) {{'current_student_id' => 3, 'user_id' => '2'}}
        its(:check) {should =~ /You've been logged out or another user is using SIMS in another window or tab./}
        its(:check) {should_not =~ /select two different students/}
        its(:check) {should =~ /Using multiple windows or tabs can cause errors or misplaced data in SIMS.  If you are seeing this message/ }
      end

      describe 'with mismatching student' do
        let(:params) {{'current_student_id' => 33, 'user_id' => '1'}}
        its(:check) {should_not =~ /You've been logged out or another user is using SIMS in another window or tab./}
        its(:check) {should =~ /select two different students/}
        its(:check) {should =~ /Using multiple windows or tabs can cause errors or misplaced data in SIMS.  If you are seeing this message/ }
      end

      describe 'with neither matching' do
        let(:params) {{'current_student_id' => 333, 'user_id' => '31'}}
        its(:check) {should =~ /You've been logged out or another user is using SIMS in another window or tab./}
        its(:check) {should =~ /select two different students/}
        its(:check) {should =~ /Using multiple windows or tabs can cause errors or misplaced data in SIMS.  If you are seeing this message/ }

      end

    end


    describe 'with user_id matching and no student' do
      its(:check) {""}
    end

  end
end

