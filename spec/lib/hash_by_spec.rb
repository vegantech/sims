require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'hash_by'
describe 'hash_by' do
  before :all do
    @base_object = [{:dog=>'fido',:cat=>'mooch'}, {:dog=>'fluffy'}]
  end
  it 'should work hash by the key and the whole object' do
    @base_object.hash_by(:dog).should == {'fido' => {:dog=>'fido', :cat=>'mooch'}, 'fluffy' =>  {:dog=>'fluffy'} }
  end

  it 'should work hash by the key and the given obj piece' do
    @base_object.hash_by(:dog,:cat).should == {'fido' => 'mooch', 'fluffy' => nil}
  end




end

