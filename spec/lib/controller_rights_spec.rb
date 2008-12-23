require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


class ApplicationController < ActionController::Base
  include ControllerRights
end

module NameSpaced
  class BoringController < ApplicationController
    
  end

  class NotDefaultController < ApplicationController
    def to_s
      "First Friendly Name"
    end
  end
end


class UseDefaultController < ApplicationController
end

class OverrideDefaultController < ApplicationController
  def to_s
     "Second Friendly Name"
  end
end


describe ControllerRights do 

  describe 'to_s' do
    it 'should provide friendly output' do
      "#{ApplicationController.new}".should == 'Application'
      "#{NameSpaced::BoringController.new}".should == 'Name Spaced/Boring'
      "#{UseDefaultController.new}".should == "Use Default"
      "#{NameSpaced::NotDefaultController.new}".should == "First Friendly Name"
      "#{OverrideDefaultController.new}".should == "Second Friendly Name"
    end
  end

end
