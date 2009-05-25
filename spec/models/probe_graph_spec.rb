require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbeGraph do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    pending
  end

  describe 'benchmark_line' do
    before do
      @ipa = InterventionProbeAssignment.new
      @probe_graph = ProbeGraph.new(@ipa)
      @probe_graph.line_width = 52
      @probe_graph.pos_bottom = 0

    end
    it 'should be empty_string if N/A' do
      @probe_graph.benchmark =  {:score => 'N/A', :grade_level => 'N/A'}
      @probe_graph.send(:benchmark_line).should == ''
    end

    describe 'with a single benchmark of 10' do
      it 'should return a line' do
        @probe_graph.should_receive(:scale_graph_value).and_return(10)
        @probe_graph.benchmark =  {:score => '10'}
        @probe_graph.send(:benchmark_line).should == '<div style="position: absolute; bottom: 10px !important; height: 15px; width: 52px; border-bottom: 1px solid orange;">&nbsp;10</div>'
      end
    end

    it 'should return a line for a benchmark of 11' do
        @probe_graph.should_receive(:scale_graph_value).and_return(11)
      @probe_graph.benchmark =  {:score => '11'}
      @probe_graph.send(:benchmark_line).should == '<div style="position: absolute; bottom: 11px !important; height: 15px; width: 52px; border-bottom: 1px solid orange;">&nbsp;11</div>'
    end
  end

  describe 'setup_data_min_and_data_max' do
    it 'should have other tests' do
      pending
    end

    it 'should work when there is no minimum or maximum, and a single bar at 0' do
      ipa=InterventionProbeAssignment.new
      @probe_graph=ProbeGraph.new(ipa)
      @probe_graph.bars << ProbeBar.new(:index=>1, :score => 0)
      @probe_graph.minimum=nil
      @probe_graph.maximum=nil
      @probe_graph.send(:setup_data_min_and_data_max)
    end
    

  end
end
