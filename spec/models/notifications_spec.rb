require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'
require 'spec'

describe Notifications do

  CHARSET = 'utf-8'
  include ActionMailer::Quoting

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

  def test_principal_override_request
    pending
    @expected.subject = 'Notifications#principal_override_request'
    @expected.body    = read_fixture('principal_override_request')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_principal_override_request(@expected.date).encoded
  end

  def test_principal_override_response
    pending
    @expected.subject = 'Notifications#principal_override_response'
    @expected.body    = read_fixture('principal_override_response')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_principal_override_response(@expected.date).encoded
  end

  def test_intervention_starting
    pending 'I need to do this test,  I changed the implementation but not this.'
    @expected.subject = 'Notifications#intervention_starting'
    @expected.body    = 'Intervention_Starting
'
    @expected.date    = Time.now


    assert_equal @expected.encoded, Notifications.create_intervention_starting(@expected.date).encoded
  end

  def test_intervention_ending_reminder
    pending
    @expected.subject = 'Notifications#intervention_ending_reminder'
    @expected.body    = read_fixture('intervention_ending_reminder')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_intervention_ending_reminder(@expected.date).encoded
  end

  def test_intervention_reminder
    pending
    @expected.subject = 'Notifications#intervention_reminder'
    @expected.body    = read_fixture('intervention_reminder')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_intervention_reminder(@expected.date).encoded
  end

  def test_intervention_participant_added
    pending
    @expected.subject = 'Notifications#intervention_participant_added'
    @expected.body    = read_fixture('intervention_participant_added')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_intervention_participant_added(@expected.date).encoded
  end

end
