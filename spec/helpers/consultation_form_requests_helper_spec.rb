require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequestsHelper do
  include ConsultationFormRequestsHelper
  describe 'hide_or_show_consultation_form' do
    it 'should hide it when show_consultation_form is false' do
      self.should_receive(:show_consultation_form?).and_return(false)
      hide_or_show_consultation_form('').should == 'display:none'
    end

    it 'should show the form (be blank) when show_consultation_form is true' do
      self.should_receive(:show_consultation_form?).and_return(true)
      hide_or_show_consultation_form('').should be_blank
    end
  end
  describe 'show_consultation_form' do
    it 'should return true when the form is filled in' do
      o=mock_object(:filled_in? => true,:school_team => SchoolTeam.new)
      f=mock_object(:object => o)
      show_consultation_form?(f).should be_true
    end
    it 'should retrun true when the team is nil and @teams is undefined' do
      o=mock_object(:filled_in? => false,:school_team => nil)
      f=mock_object(:object => o)
      show_consultation_form?(f).should be_true
    end
    it 'should return true when the team has no assets' do
      o=mock_object(:filled_in? => false,:school_team => SchoolTeam.new)
      f=mock_object(:object => o)
      show_consultation_form?(f).should be_true
    end
    it 'should return false when the team is present, has assets, and the object is not filled in' do
      o=mock_object(:filled_in? => false,:school_team => SchoolTeam.new(:assets => [Asset.new]))
      f=mock_object(:object => o)
      show_consultation_form?(f).should be_false
    end
    it 'should return false when no team is present, but the first team in @teams has assets, and the object is not filled in' do
      o=mock_object(:filled_in? => false,:school_team => nil)
      @teams = [SchoolTeam.new(:assets => [Asset.new])]
      f=mock_object(:object => o)
      show_consultation_form?(f).should be_false
    end
  end
  describe 'show_or_hide_form_onchange' do
    it 'should provide a list with no team ids if no teams have assets' do
      show_or_hide_form_onchange.should == {:onchange=>"show_or_hide_team_consultation_form(this,'[]');"}
    end
    it 'should provide a list with the team ids having assets' do
      team1_with_assets = mock_school_team(:id => 1, :assets => ['yes'])
      team2_without_assets = mock_school_team(:id => 2,:assets => [])
      team3_with_assets =mock_school_team(:id => 3, :assets => ['indeed'])
      @teams = [team1_with_assets,team2_without_assets,team3_with_assets]
      show_or_hide_form_onchange.should == {:onchange=>"show_or_hide_team_consultation_form(this,'[1,3]');"}
    end

  end
  describe 'team_consultation_form' do
    it 'should create when the team_consultation is new' do
      team_consultation_form(TeamConsultation.new){}.should == "<form action=\"/team_consultations.js\" class=\"new_team_consultation\" enctype=\"multipart/form-data\" id=\"new_team_consultation\" method=\"post\" target=\"upload_frame\"></form>"
    end
    it 'should update when updating (a draft)' do
      team_consultation = mock_team_consultation(:id => 7, :new_record? => false)
      team_consultation_form(team_consultation){}.should ==
        "<form action=\"/team_consultations/7.js\" class=\"edit_team_consultation\" enctype=\"multipart/form-data\" id=\"edit_team_consultation_7\" method=\"post\" target=\"upload_frame\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"_method\" type=\"hidden\" value=\"put\" /></div></form>"
    end
  end
end
