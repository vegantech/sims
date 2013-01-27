require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConsultationFormRequestsHelper do
  describe 'hide_or_show_consultation_form' do
    it 'should hide it when show_consultation_form is false' do
      helper.should_receive(:show_consultation_form?).and_return(false)
      helper.hide_or_show_consultation_form('').should == 'display:none'
    end

    it 'should show the form (be blank) when show_consultation_form is true' do
      helper.should_receive(:show_consultation_form?).and_return(true)
      helper.hide_or_show_consultation_form('').should be_blank
    end
  end
  describe 'show_consultation_form' do
    before do
      district = mock_district(:show_team_consultation_attachments? => true)
      helper.stub!(:current_district=>district)
    end
    it 'should return true when the form is filled in' do
      o=mock(:filled_in? => true,:school_team => SchoolTeam.new)
      f=mock(:object => o)
      helper.show_consultation_form?(f).should be_true
    end
    it 'should retrun true when the team is nil and @teams is undefined' do
      o=mock(:filled_in? => false,:school_team => nil)
      f=mock(:object => o)
      helper.show_consultation_form?(f).should be_true
    end
    it 'should return true when the team has no assets' do
      o=mock(:filled_in? => false,:school_team => SchoolTeam.new)
      f=mock(:object => o)
      helper.show_consultation_form?(f).should be_true
    end
    it 'should return false when the team is present, has assets, and the object is not filled in' do
      o=mock(:filled_in? => false,:school_team => SchoolTeam.new(:assets => [Asset.new]))
      f=mock(:object => o)
      helper.show_consultation_form?(f).should be_false
    end
    it 'should return false when no team is present, but the first team in @teams has assets, and the object is not filled in' do
      o=mock(:filled_in? => false,:school_team => nil)
      @teams = [SchoolTeam.new(:assets => [Asset.new])]
      f=mock(:object => o)
      helper.show_consultation_form?(f).should be_false
    end
  end
  describe 'team_consultation_form' do
    it 'should create when the team_consultation is new' do
      helper.team_consultation_form(TeamConsultation.new){}.should ==
        "<form accept-charset=\"UTF-8\" action=\"/team_consultations.js\" class=\"new_team_consultation\" enctype=\"multipart/form-data\" id=\"new_team_consultation\" method=\"post\" target=\"upload_frame\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div></form>"
    end

    it 'should update when updating (a draft)' do
      team_consultation = mock_team_consultation(:id => 7, :new_record? => false)
      helper.team_consultation_form(team_consultation){}.should ==
        "<form accept-charset=\"UTF-8\" action=\"/team_consultations/7.js\" class=\"edit_team_consultation\" enctype=\"multipart/form-data\" id=\"edit_team_consultation_7\" method=\"post\" target=\"upload_frame\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /><input name=\"_method\" type=\"hidden\" value=\"put\" /></div></form>"
    end
  end
end
