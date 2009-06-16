require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'hash_by'
describe 'hash_by' do
  it 'should work' do
    [{:dog=>'fido'}, {:dog=>'fluffy'}].hash_by(:dog).should == {'fido' => {:dog=>'fido'}, 'fluffy' =>  {:dog=>'fluffy'} }
  end


end

