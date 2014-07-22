require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class Person
  attr_accessor :first_name, :last_name, :middle_name, :suffix
  def self.validates(*_args);end
  include FullName
  def initialize(opts)
    @first_name = opts[:first_name]
    @last_name = opts[:last_name]
    @middle_name = opts[:middle_name]
    @suffix = opts[:suffix]
  end
end

class ShortNamedPerson
  attr_accessor :first_name, :last_name
  def self.validates(*_args);end
  include FullName
  def initialize(opts)
    @first_name = opts[:first_name]
    @last_name = opts[:last_name]
  end
end

describe FullName do
  describe 'fullname' do
    it 'should be empty if the name is empty' do
      Person.new({}).fullname.should == ""
    end
    it 'should return first_name<space>last_name' do
      Person.new(first_name: "John", last_name: "Smith").fullname.should == 'John Smith'
    end

    describe 'when there is a middle name' do
      it 'should return first_name<space>middle_initial<space>last_name' do
        Person.new(first_name: "John", middle_name: 'Eisenhower', last_name: "Smith").fullname.should == 'John E. Smith'
      end

      it 'should return John E. Smith when given John E. Smith' do
        Person.new(first_name: "John", middle_name: 'E.', last_name: "Smith").fullname.should == 'John E. Smith'
      end
    end

    it 'should show the suffix' do
      Person.new(first_name: "John", middle_name: 'E', last_name: "Smith", suffix: "Jr.").fullname.should == 'John E. Smith Jr'
    end

    it 'should fix capitalization' do
      Person.new(first_name: "John", middle_name: 'E.', last_name: "DeSalvo").fullname.should == 'John E. DeSalvo'
    end

    it 'should not blow up when used by a class without middle_name or suffix' do
      ShortNamedPerson.new(first_name: 'John', last_name: 'Smith').fullname.should == 'John Smith'
    end
  end

  it 'should have to_s' do
    Person.new(first_name: "John", middle_name: 'E', last_name: "Smith", suffix: "Jr.").to_s.should == 'John E. Smith Jr'
  end

  describe 'fullname_last_first' do
    it 'should show the suffix' do
      Person.new(first_name: "John", middle_name: 'E', last_name: "Smith", suffix: "Jr.").fullname_last_first.should == 'Smith, John E. Jr'
    end
  end
end

