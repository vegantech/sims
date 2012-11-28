require "test/unit"
require "rubygems"
gem "activerecord", "3.2.0"
require "active_record"
require "active_support/core_ext/logger"

require File.expand_path(File.dirname(__FILE__) + '/../lib/validates_date_time')

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(ENV['DB'] || 'mysql')

load(File.dirname(__FILE__) + '/schema.rb')

class Person < ActiveRecord::Base
  validates_date :date_of_birth, :allow_blank => true
  validates_date :date_of_death, :allow_blank => true, :before => lambda { Date.current + 1.day }, :after => :date_of_birth

  validates_date :date_of_arrival, :allow_blank => true, :before => :date_of_departure, :after => '1 Jan 1800', :before_message => "avant %s", :after_message => "apres %s", :message => "malfaisance"

  validates_time :time_of_birth, :allow_blank => true, :before => [lambda { Time.now }]
  validates_time :time_of_death, :allow_blank => true, :after => [:time_of_birth, '7pm'], :before => [lambda { 10.years.from_now }]

  validates_date_time :date_and_time_of_birth, :allow_blank => true, :before => '2008-01-01 01:01:01', :after => '1981-01-01 01:01am'

  validates_date :required_date
end

class ActiveRecord::TestCase
  attr_reader :person

  def setup
    @person = Person.create!(:required_date => "2006-01-01")
  end

  def assert_update_and_equal(expected, attributes = {})
    assert person.update_attributes!(attributes), "#{attributes.inspect} should be valid"
    assert_equal expected, person.send(attributes.keys.first).to_s
  end

  def assert_update_and_match(expected, attributes = {})
    assert person.update_attributes(attributes), "#{attributes.inspect} should be valid"
    assert_match expected, person.send(attributes.keys.first).to_s
  end

  def assert_invalid_and_errors_match(expected, attributes = {})
    assert !person.update_attributes(attributes)
    assert_match expected, person.errors.full_messages.join("")
  end

  def with_us_date_format(&block)
    ValidatesDateTime.us_date_format = true
    yield
  ensure
    ValidatesDateTime.us_date_format = false
  end
end
