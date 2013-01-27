require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Right do
  it 'should change the cache key when rights are updated' do
    old_key = Right.cache_key
    oldrights = Right::RIGHTS
    Right.send :remove_const, "RIGHTS"
    Right.const_set "RIGHTS", 'dog'

    Right.cache_key.should_not == old_key
    Right.send :remove_const, "RIGHTS"
    Right.const_set "RIGHTS", oldrights

  end
end
