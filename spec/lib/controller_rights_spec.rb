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
  describe 'action_group_for_current_action' do
    before do
      @ac = ApplicationController.new
    end

    describe 'passed a write action' do
      it 'should return "write_access"' do
        @ac.action_name = 'create'
        @ac.send(:action_group_for_current_action).should == 'write_access'
      end
    end

    describe 'passed a read action' do
      it 'should return "read_access"' do
        @ac.action_name = 'index'
        @ac.send(:action_group_for_current_action).should == 'read_access'
      end
    end

    describe 'passed an unrecognized action' do
      it 'should return nil' do
        @ac.action_name = 'fubar'
        @ac.send(:action_group_for_current_action).should be_nil
      end
    end
  end

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