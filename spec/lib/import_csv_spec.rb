require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImportCSV do
  describe 'starts_with?' do
    before do
      @expected_head = ['first','second','third']
    end

  #string nonzip 
    #string zip
      #file nonzip
        #file zip

   
    it 'should be true when they are identical' do
      ImportCSV.send(:starts_with?, @expected_head,['first','second', 'third']).should be_true
    end

    it 'should be true when all the expected head is there and there is some extra stuff after' do
      ImportCSV.send(:starts_with?, @expected_head,['first','second','third', 'fourth']).should be_true
    end

    it 'should be false when the elements are not in the proper order' do
      ImportCSV.send(:starts_with?, @expected_head,['first','third','second', 'fourth']).should be_false
    end

    it 'should be false when there is no match' do
      ImportCSV.send(:starts_with?, @expected_head,['no']).should be_false
    end
    
    it 'should be false when there are parts missing' do
      ImportCSV.send(:starts_with?, @expected_head,['first']).should be_false
    end

  end

  describe 'sort_files' do
    # ['schools.csv', 'students.csv', 'users.csv']
    
    it 'should sort with the required files first' do
      i=ImportCSV.new '', District.new
      i.send(:sorted_filenames, ['dog.csv', 'users.csv','schools.csv']).should == ['schools.csv', 'users.csv', 'dog.csv']
      i.send(:sorted_filenames, ['/tmp/Dog.csv', '/a/users.csv','/b/SChOOls.csv']).should == ['/b/SChOOls.csv', '/a/users.csv', '/tmp/Dog.csv']
    end
  end


end

