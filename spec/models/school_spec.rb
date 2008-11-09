require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe School do

  describe 'grades_by_user' do
    it 'should return all grades in school when user has access to 
    all students in the school' do
      pending
    end

    it 'should return subset of grades in the school where there is at least one student that the user has access to' do
      pending
    end

    it 'should prepend * if there is more than one' do
      pending
    end
    
    it 'should not prepend * if there is only one' do
      pending
    end
  end
end
