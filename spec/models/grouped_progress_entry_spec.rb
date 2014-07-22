require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GroupedProgressEntry do
  before(:each) do
  end

  it "should have some specs"

  it "should test intervention probe assignments that are not enabled [#494]"

  it 'should add participants and send emails' do
    pending 'TEST ME'

  end

  describe 'end_intervention!' do
    before do
      @gpe = GroupedProgressEntry.allocate
      @mock_intervention1 = double(:intervention, :id => 1)
      @mock_intervention2 = double(:intervention, :id => 2)

      @gpe.should_receive(:student_interventions).and_return([@mock_intervention1, @mock_intervention2])

    end

    it 'should do nothing when there are no end_intervention passed in' do
      @mock_intervention1.should_not_receive :end
      @mock_intervention2.should_not_receive :end
      @gpe.end_interventions! nil, '', ''
    end

    it 'should send end when there are matching ids' do
      @mock_intervention1.should_receive :end
      @mock_intervention2.should_not_receive :end
      @gpe.end_interventions! [@mock_intervention1.id.to_s], '', ''
    end

    it 'should ignore invalid ids (that are not part of the group or assigned to user' do
      @mock_intervention1.should_not_receive :end
      @mock_intervention2.should_not_receive :end
      @gpe.end_interventions! [:invalid, :other], '', ''

    end

  end

end
