require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe 'Use Old Fixtures Key' do
  #A lot of the seeding, imports, and tests depend on the ids....
  describe "Fixtures.identify" do
    it "should match the earlier rails2.3 and ruby 1.8.6 values" do
      Fixtures.identify(:alpha_first_attendance).should == 184330814 #used in a feature
      Fixtures.identify(:recommendation_answer_definition_00001).should == 2066095351   #used for seeding new districts
      Fixtures.identify(:weekly).should == 1591519780  #also used for seeding new districts

      Fixtures.identify(:district_admin).should == 659073605  #used in a feature, but updated there to use the new fixture identifier


    end
  end
end
