require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagsHelper do
  include FlagsHelper
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(FlagsHelper)
  end

  describe 'status_display' do
    it 'should combine intervention current and custom flags' do
      student="STUDENT"
      change="CHANGE"
      self.should_receive(:intervention_status).with(student).and_return("INTERVENTION STATUS ")
      self.should_receive(:current_flags).with(student,change).and_return('CURRENT FLAGS ')
      self.should_receive(:ignore_flags).with(student).and_return('IGNORE FLAGS ')
      self.should_receive(:custom_flags).with(student).and_return('CUSTOM FLAGS')
      status_display(student,change).should =='INTERVENTION STATUS CURRENT FLAGS IGNORE FLAGS CUSTOM FLAGS'
    end
  end

  describe 'image_with_popup' do
    it 'should return an imagetag with an onmouseover and onmouse_out' do
      result = image_with_popup("dog.jpg", "This is the popup")
      result.should == %q{<img alt="Dog" onmouseout="return nd();" onmouseover="return overlib('This is the popup');" src="/images/dog.jpg" /> }
    end
  end

  describe 'custom flags' do
    it 'should return empty string when student has no custom flags' do
      pending
      student=mock_student
      student.stub_association!(:flags,:custom=>[])
      custom_flags(student).should == ""
    end

    it 'should show the custom flag icon with the summary as a popup' do
      pending
      student=mock_student
      flag=mock_flag(:summary=>"Custom Flag Summary", :any? =>true)
      student.stub_association!(:flags,:custom=>flag)
      self.should_receive(:image_with_popup).with("C.gif", 'C: Custom Flags- Custom Flag Summary').and_return('RSPEC CUSTOM FLAGS')
      custom_flags(student).should == "RSPEC CUSTOM FLAGS"

    end
  end

  describe 'current_flags' do
    before do
      @student=mock_student
    end

    describe 'without flags' do
      it 'should return blank string' do
        pending
        @student.stub_association!(:flags,:current=>{})
        current_flags(@student).should == ""
      end
    end

    describe 'with flags' do
      it 'should show current flags' do
        pending
      end
    end
  end



  describe 'custom_flags' do
    it 'should be tested' do
      pending
    end
  end

  describe 'flag_select' do 
    it 'should be tested' do
      pending
    end
  end

  describe 'flag_checkbox' do
    it 'should be tested' do
      pending
    end
  end

  describe 'display_flag_legend?' do
    it 'should be tested' do
      pending
    end
  end
  
  describe 'intervention_status' do
    it 'should be tested' do
      pending
    end

  end


=begin

  def status_display(student, change = nil)
    10     str = intervention_status(student)
    11 
    12     student.flags.current.each do |flagtype,flags|
      13       popup="#{Flag::FLAGTYPES[flagtype][:icon].split('.').first.upcase}: #{flags.collect(&:summary).join(" ")}"
      14       str += displayflag(Flag::FLAGTYPES[flagtype][:icon],popup, flagtype, student)      
      15     end
    16 
    17     if change.nil? && student.flags.any?
    18       popup="C: Custom Flags- #{student.flags.custom_summary}"
    19       str += image_tag("C.gif",
                              20       "onmouseover" => "return overlib('#{popup}');",
                              21       "onmouseout" => "return nd();")
                              22     end
  23 
  24     str
  25   end
  26 
  27   def flag_select
  28     Flag::ORDERED_TYPE_KEYS.inject(''){|result,flagtype| result += flag_checkbox(flagtype)}
  29   end
  30 
  31   def flag_checkbox(flagtype)
  32     f = Flag::TYPES[flagtype.to_s]
  33     check_box_tag("flagged_intervention_types[]", flagtype, false,:id=>"flag_#{flagtype}", :onclick=>"searchByFlag()") +
    34     content_tag(:label, image_tag(f[:icon], :title=>f[:humanize]), {'for' => "flag_#{flagtype}"})
  35   end
  36 
  37   def display_flag_legend?(&block)
  38     yield if controller.controller_name=="students"
  39   end
  40 
  41   def intervention_status(student)
  42     str = ''
  43     if student.interventions.active.any?
  44       popup =  student.interventions.active.collect(&:title).join('<br />')
  45       str += image_tag("green-dot.gif",
                            46         "onmouseover" => "return overlib('#{popup}');",
                            47         "onmouseout" => "return nd();") + " "
                            48     end
  49     
  50     if student.interventions.inactive.any?
  51       popup =  student.interventions.inactive.collect(&:title).join('<br />')
  52       str += image_tag("gray-dot.gif",
                            53         "onmouseover" => "return overlib('#{popup}');",
                            54         "onmouseout" => "return nd();") + " "
                            55     end
  56   str
  57   end
  58  
  59 end


=end  
end
