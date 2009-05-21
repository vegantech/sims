require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe TeamReferrals do
  describe "concern_note_created" do
    it 'should' do
      pending
      
      @expected.subject = 'TeamReferrals#concern_note_created'
      @expected.body    = read_fixture('concern_note_created')
      @expected.date    = Time.now

      TeamReferrals.create_concern_note_created(@expected.date).encoded.should == @expected.encoded
    end
  end

  describe "gather_information_request" do
    it 'should' do
      pending
      @expected.subject = 'TeamReferrals#gather_information_request'
      @expected.body    = read_fixture('gather_information_request')
      @expected.date    = Time.now

      TeamReferrals.create_gather_information_request(@expected.date).encoded.should == @expected.encoded
    end
  end

end
