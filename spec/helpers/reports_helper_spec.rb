require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsHelper do
  include ReportsHelper

  describe 'subreport_selected' do
    describe 'passed "1"' do
      it 'should execute passed in code block' do
        m = mock_object
        m.should_receive(:message).and_return(false)
        subreport_selected('1') {m.message}
      end
    end

    describe 'not passed "1"' do
      it 'should not execute code block' do
        m = 'mock'
        m.should_not_receive(:message)
        subreport_selected('0') {m.message}
      end
    end
  end
end
