require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PersonalGroup do
  describe 'name' do
    it 'should exist and be unique for a school/user' do
      PersonalGroup.new.should_not be_valid
      pg1 = PersonalGroup.create!(:name => 'pg1', :school_id => 1, :user_id => 1)
      PersonalGroup.new(:name=>'pg1',:school_id => 1, :user_id => 1).should_not be_valid
      PersonalGroup.new(:name=>'pg1',:school_id => 2, :user_id => 1).should be_valid
      PersonalGroup.new(:name=>'pg1',:school_id => 1, :user_id => 2).should be_valid
    end
  end

  describe 'aliases' do
    before :all do
      @pg = PersonalGroup.new :name => 'pg1'
      @pg.id = 665
    end

    it 'should alias title' do
      @pg.title.should == 'pg1'
    end

    it 'should have id_with_prefix' do
      @pg.id_with_prefix.should == 'pg665'
    end
  end

  describe 'to_test' do
    it 'by_school'
    it 'by_grade'
    it 'by_school_and_grade class method'
  end

  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    PersonalGroup.create!(@valid_attributes)
  end
end
