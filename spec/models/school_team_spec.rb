# == Schema Information
# Schema version: 20101101011500
#
# Table name: school_teams
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  name       :string(255)
#  anonymous  :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolTeam do

  describe 'updating' do
    subject {SchoolTeam.create! :anonymous => true, :user_ids => [bob.id], :contact_ids => [alice.id,contact.id]}
    let(:alice) {FactoryGirl.create(:user, :username => 'alice')}
    let(:bob) {FactoryGirl.create(:user, :username => 'bob')}
    let(:contact) {FactoryGirl.create(:user, :username => 'contact')}
    let(:cara) {FactoryGirl.create(:user, :username => 'cara')}

    describe 'remove contact alice from team' do
      it 'should not have alice as member' do
        subject.update_attributes :contact_ids => [contact.id], :user_ids => [bob.id]
        subject.users.should =~ [bob,contact]
        subject.team_contacts.should == [contact]
      end
    end
    describe 'demote contact alice to memeber' do
      it 'should have alice as member' do
        #787 lh
        subject.update_attributes :contact_ids => ["",contact.id], :user_ids => [alice.id,bob.id]
        subject.reload.users.should =~ [bob,contact,alice]
        subject.team_contacts.should == [contact]
      end
    end
    describe 'promote member bob to contact' do
      it 'should have bob as contact' do
        subject.update_attributes :contact_ids => [contact.id,bob.id,alice.id], :user_ids => []
        subject.users.should =~ [bob,contact,alice]
        subject.team_contacts.should =~ [bob,contact,alice]
      end
    end
    describe 'add new person cara as contact' do
      it 'should have cara as contact' do
        subject.update_attributes :contact_ids => [contact.id,cara.id,alice.id], :user_ids => [bob.id]
        subject.users.should =~ [bob,contact,alice,cara]
        subject.team_contacts.should =~ [contact,alice,cara]

      end
    end
    describe 'no contact.id' do
      it 'should not make any membership changes' do
        subject.update_attributes :contact_ids => [], :user_ids => [bob.id,cara.id], :anonymous => false
        subject.users.should =~ [bob,contact,alice]
        subject.team_contacts.should =~ [contact,alice]
      end
    end

    describe 'no name and not anonymous' do
      it 'should not make any membership changes' do
        subject.update_attributes :contact_ids => [cara.id], :user_ids => [bob.id,cara.id], :anonymous => false
        subject.users.should =~ [bob,contact,alice]
        subject.team_contacts.should =~ [contact,alice]
      end
    end

  end
end
