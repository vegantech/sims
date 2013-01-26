# == Schema Information
# Schema version: 20101101011500
#
# Table name: team_consultations
#
#  id           :integer(4)      not null, primary key
#  student_id   :integer(4)
#  requestor_id :integer(4)
#  team_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  complete     :boolean(1)
#  draft        :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamConsultation do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    TeamConsultation.create!(@valid_attributes)
  end

  describe 'recipients' do
    it 'should return an empty array when there is no school team' do
      #LH 463
      TeamConsultation.new.recipients.should be_empty

    end

    it 'should return an array of users when there is a school team'

  end

  it 'should test complete' do
    tc=TeamConsultation.create!(:complete => false)
    tc.complete!
    tc.reload.complete.should be_true
  end
  it 'should test incomplete' do
    #656
    tc = TeamConsultation.create(:complete => true)
    tc.undo_complete!
    tc.reload.complete.should be_false
  end

  describe 'pending_for_user' do
    it 'should have drafts for the user, and open consultations' do
      u=Factory(:user)
      @open_consultation = TeamConsultation.create!
      @closed_consultation = TeamConsultation.create! :complete => true
      @draft_by_user = TeamConsultation.create! :requestor => u, :draft => true
      @draft_other_user = TeamConsultation.create! :draft => true, :requestor => User.new
      TeamConsultation.pending_for_user(u).should =~ [@open_consultation, @draft_by_user]
    end
  end
end
