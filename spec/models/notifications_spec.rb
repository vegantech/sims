require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Notifications do

  CHARSET = 'utf-8'
#  include ActionMailer::Quoting

  before do
        # You don't need these lines while you are using create_ instead of deliver_
    #     #ActionMailer::Base.delivery_method = :test
    #         #ActionMailer::Base.perform_deliveries = true
    #             #ActionMailer::Base.deliveries = []
    #
      @expected = TMail::Mail.new
      @expected.set_content_type 'text', 'plain', { 'charset' => CHARSET }
      @expected.mime_version = '1.0'
    end

  it 'test_principal_override_request' do
    pending
    @expected.subject = 'Notifications#principal_override_request'
    @expected.body    = read_fixture('principal_override_request')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_principal_override_request(@expected.date).encoded
  end

  it 'test_principal_override_response' do
    pending
    @expected.subject = 'Notifications#principal_override_response'
    @expected.body    = read_fixture('principal_override_response')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_principal_override_response(@expected.date).encoded
  end

  it 'test_intervention_starting' do
    pending 'I need to do this test,  I changed the implementation but not this.'
    @expected.subject = 'Notifications#intervention_starting'
    @expected.body    = 'Intervention_Starting
'
    @expected.date    = Time.now


    assert_equal @expected.encoded, Notifications.create_intervention_starting(@expected.date).encoded
  end

  it 'test_intervention_ending_reminder' do
    pending
    #be sure to test conditions where the  author, or participant no longer exists
    @expected.subject = 'Notifications#intervention_ending_reminder'
    @expected.body    = read_fixture('intervention_ending_reminder')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_intervention_ending_reminder(@expected.date).encoded
  end

  it 'test_intervention_reminder' do
    pending
    @expected.subject = 'Notifications#intervention_reminder'
    @expected.body    = read_fixture('intervention_reminder')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_intervention_reminder(@expected.date).encoded
  end

  it 'test_intervention_participant_added' do
    pending
    @expected.subject = 'Notifications#intervention_participant_added'
    @expected.body    = read_fixture('intervention_participant_added')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_intervention_participant_added(@expected.date).encoded
  end

  describe 'setup_ending_intervention_reninder' do
    it 'should deliver emails in interventions_ending_this week'  do
      m=mock_intervention(:participants_with_author => [mock_object(:user=>mu=mock_user)],:student => mock_student(:belongs_to_user? => true))
      Notifications.should_receive(:interventions_ending_this_week).and_return([m])
      Notifications.should_receive(:deliver_intervention_ending_reminder).with(mu,[m]).and_return(false)
      Notifications.setup_ending_reminders
    end
  end

  describe 'interventions_ending_this_week' do
    it 'should return empty array when there are no interventions ending this week' do
      Notifications.interventions_ending_this_week.should == []
    end

    it 'should return array containing due_this_week' do
      past=create_without_callbacks(Intervention,:end_date => 2.days.ago)
      future_already_ended=create_without_callbacks(Intervention,:end_date => 2.days.from_now, :active => false)
      due_this_week_with_student = create_without_callbacks(Intervention,:end_date => 2.days.from_now, :student => Factory(:student))
      due_next_week = create_without_callbacks(Intervention, :end_date => 9.days.from_now)

      Notifications.interventions_ending_this_week.should == [due_this_week_with_student]
    end

    it 'should eliminate interventions without students' do
      due_this_week_without_student = create_without_callbacks(Intervention,:end_date => 2.days.from_now)
      Notifications.interventions_ending_this_week.should == []

    end

  end

  def create_without_callbacks(o, opts={:tier=>@tier})
   obj=o.new(opts)
   obj.send(:create_without_callbacks)
   obj 
  end   


end
