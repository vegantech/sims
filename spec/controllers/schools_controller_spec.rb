require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SchoolsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

end
