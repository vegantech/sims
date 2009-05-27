# == Schema Information
# Schema version: 20090524185436
#
# Table name: checklists
#
#  id                      :integer         not null, primary key
#  checklist_definition_id :integer
#  from_tier               :integer
#  student_id              :integer
#  promoted                :boolean
#  user_id                 :integer
#  is_draft                :boolean         default(TRUE)
#  district_id             :integer
#  created_at              :datetime
#  updated_at              :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'
require 'spec'

describe Checklist do
  fixtures :element_definitions, :checklists, :checklist_definitions, :answers, :answer_definitions, :students,:users, :districts
  self.use_instantiated_fixtures = true

  before do
    @valid_attributes = {
      :checklist_definition => 1,
      :from_tier => "1",
      :student => 1,
      :promoted => false,
      :user => 1,
      :is_draft => false,
      :district =>  1
    }
  end

  describe 'new_from_teacher class method' do
    before do
      @t = mock_user
      @s = Factory(:student)
    end

    describe 'not associated with a student' do
      it 'should return nil' do
        Checklist.new_from_teacher(@t).should be_nil
      end
    end

    describe 'associated with a student' do
      describe 'and student has valid values' do
        before do
          @cd = Factory(:checklist_definition)
          @tier = Factory(:tier)
          @s.should_receive(:checklist_definition).and_return(@cd)
          @s.should_receive(:max_tier).and_return(@tier)
          @s.should_receive(:district_id).and_return(15)
          Student.should_receive(:find).with(@s.id, {:conditions => nil, :readonly => nil, :select => nil, :include => nil}).and_return(@s)
        end

        describe 'and the student checklist we are copying still exists' do
          before do
            @old_cl = mock_checklist(:answers => [Factory(:answer)], :score_results => 'Score Results')
            Checklist.should_receive(:find_by_checklist_definition_id).and_return(@old_cl)
          end

          describe 'and the student checklist says to show score' do
            it 'should populate values and copy student checklist attributes' do
              @old_cl.should_receive(:show_score?).with(false).and_return(true)
              @old_cl.should_receive(:score_checklist)

              cl = @s.checklists.new_from_teacher(@t)

              cl.student.should == @s
              cl.should_not be_nil
              cl.checklist_definition.should == @cd
              cl.tier.should == @tier
              cl.district_id.should == 15

              # check the copied attributes
              cl.answers.size.should == @old_cl.answers.size
              cl.score_results.should == 'Score Results'
            end
          end

          describe 'and the student checklist says to not show score' do
            it 'should populate values and copy student checklist attributes but not call score_checklist' do
              @old_cl.should_receive(:show_score?).with(false).and_return(false)

              cl = @s.checklists.new_from_teacher(@t)

              cl.student.should == @s
              cl.should_not be_nil
              cl.checklist_definition.should == @cd
              cl.tier.should == @tier
              cl.district_id.should == 15

              # check the copied attributes
              cl.answers.size.should == @old_cl.answers.size
              cl.score_results.should == 'Score Results'
            end
          end
        end

        describe 'and student has a since-deleted checklist_definition' do
          it 'should not copy student checklist attributes' do
            Checklist.should_receive(:find_by_checklist_definition_id).and_return(nil)

            cl = @s.checklists.new_from_teacher(@t)

            cl.student.should == @s
            cl.should_not be_nil
            cl.checklist_definition.should == @cd
            cl.tier.should == @tier
            cl.district_id.should == 15

            # there should be no copied attributes
            cl.answers.size.should == 0
            cl.score_results.should be_nil
          end
        end
      end
    end
  end

  it "should create a new instance given valid attributes" do
    pending 'Test:Unit for now'
    # Checklist.create!(@valid_attributes)
  end

  describe 'pending?' do
    it 'should have specs for pending?' do
      pending
    end
  end

  describe 'missing_checklist_definition?' do
    it 'should have specs for missing_checklist_definition?' do
      pending
    end
  end

  def setup
    @student=Student.new()
    @student.first_name="Frist"
    @student.last_name="last"
    @element_definition = @element_definion_one
    @checklist=Checklist.find(:first)
    @checklist_definition = @checklist.checklist_definition
    @student.district=@checklist_definition.district
    @student.save!
  end

  def assert_validity(obj, options ={})
    message = "#{options[:message]}#{obj.class.to_s.titleize} was invalid: \n#{obj.errors.to_yaml}"
    assert obj.valid?, message
  end

  def test_new_from_student_and_teacher
    #Empty Checklists
    pending
    Checklist.destroy_all
    Answer.destroy_all
    @teacher=User.find(:first)
    @checklist = new_from_student_and_teacher_permutation{|checklist,ig1,ig2| return checklist}
    @checklist.answers.create!(:answer_definition=>@answer_definition_one)
    @checklist.save!
    @checklist.recommendations.create!(:should_advance=>true, :progress=>1,:recommendation=>4)
    assert @checklist.show_score?
    new_from_student_and_teacher_permutation{|checklist,import_previous_answers,score|
    assert checklist.score_results if score
    assert !checklist.answers.blank? if import_previous_answers
    @checklist=checklist and checklist.save! if score and import_previous_answers
    }
    @checklist.recommendations.create!(:should_advance=>true, :progress=>1,:recommendation=>4)
    assert @checklist.passed, @checklist.score_results
    @checklist=Checklist.new_from_student_and_teacher(@student,@teacher,true,true)
    assert !@checklist.answers.blank?
    assert !@checklist.show_score?
    @checklist.save!
    @checklist=Checklist.new_from_student_and_teacher(@student,@teacher,true,true)
    assert !@checklist.answers.blank?
    assert !@checklist.show_score?
    
    
    #should test this with existing checklists  
    #1. most recent one is scorable  (has score and answers)
    #2. most recent one passed (no score, should import answers)
    #3. most one is not scorable (no score should import answers)
    
    end
    
    def new_from_student_and_teacher_permutation(&block)
    
    [true,false].each do |import_previous_answers|
      [true,false].each do |score|
        message="score #{score} import_previous #{import_previous_answers}"
        checklist=Checklist.new_from_student_and_teacher(@student,@teacher,import_previous_answers,score)
        assert_validity checklist, :message=>"invalid #{message}"
        assert (score or checklist.score_results.blank?) , message
        #checkist should not have score results unless score is true
        assert checklist.is_draft?,message
        assert !checklist.promoted ,message
        yield checklist,score,import_previous_answers if block
      end
      
    end
       
    #creating passing checklist (with recommendation and test more)
  end
  
  def test_new_from_params_and_teacher
    @saElement=ElementDefinition.create!(:text=>"Short Answer", :question_definition_id=>1, :kind=>:sa)
    @commentElement=ElementDefinition.create!(:text=>"Comment", :question_definition_id=>1, :kind=>:comment)
    @scaleElement=ElementDefinition.create!(:text=>"Scale", :question_definition_id=>1, :kind=>:scale)
    Answer.delete_all
 
 
    params={:student_id=>@student.id, :element_definition=>{@saElement.id=>{:element_definition_id=>@saElement.id,:id=>2,:text=>"Short Answer content"},
    @commentElement.id=>{:id=>3,:text=>"Comment content",:element_definition_id=>@commentElement.id,},
    @scaleElement.id=>{:id=>4,:element_definition_id=>@scaleElement.id,}
    } 
    }
    
    
    #@chk=Checklist.new_from_params_and_teacher(params,@teacher)
   # assert_equal 3,@chk.answers.count
    
   # @chk.save!
   # assert_equal 3,Answer.count
    
  end
  
  def test_previous_answer_for_no_checklists
    Checklist.destroy_all
    Answer.destroy_all
    assert_nil @student.checklists.build.previous_answer_for(@element_definition), "No checklists"
  end
  
  def test_previous_answer_for_empty_existing_checklist
    Checklist.destroy_all
    @student.checklists.create
    assert_nil @student.checklists.build.previous_answer_for(@element_definition), "Existing empty checklist"
    @student.checklists.create
    assert_nil @student.checklists.build.previous_answer_for(@element_definition), "Existing empty checklist"
  end


  def test_previous_answer_for_existing_checklist_with_answers
    pending

    Checklist.destroy_all
    Answer.delete_all
    def_opts={:user_id=>4, :from_tier=>1, :checklist_definition_id=>1}
    @checklist=@student.checklists.create(def_opts)
    assert_not_nil @checklist.created_at
    @answer=@checklist.answers.build
    @answer.answer_definition=@element_definition.answer_definitions.first
    @answer.save
    assert_not_nil @answer.created_at
    
    assert_equal @answer, @student.checklists.build.previous_answer_for(@element_definition), "previous checklist, element has answer"
    assert_nil @student.checklists.build.previous_answer_for(@element_definition_two), "previous checklist, element has no answer"
    @checklist2=@student.checklists.create(def_opts)
    assert_not_nil @checklist2.created_at

    @answer2=@checklist2.answers.build
    @answer2.answer_definition=@element_definition.answer_definitions.last
    @answer2.save
    assert_equal 2,Answer.count
    assert Answer.find_all_by_element_definition(@element_definition).include?(@answer2)
    assert Answer.find_all_by_element_definition(@element_definition).include?(@answer)
    assert_equal @answer2, @student.checklists.build.previous_answer_for(@element_definition), "Existing checklist (2) element has answer"
  end
  
  def test_all_valid?
    @checklist.user_id=2
    @checklist.student_id=nil
    assert !@checklist.all_valid?
    @checklist.student_id=1
    assert @checklist.all_valid?


  end

  def test_definition_references
    [:text, :directions, :question_definitions].each do |r|
    assert_equal @checklist.send(r), @checklist_definition.send(r)
    end
  end

  def test_element_definitions_for_answers
    assert_equal @checklist.element_definitions_for_answers.size, @checklist.answers.size
    assert_equal @checklist.answers.first.answer_definition.element_definition, @checklist.element_definitions_for_answers.first
    assert_equal @checklist.element_definitions_for_answers.first.class, ElementDefinition
  end

  def test_status
   # assert_equal Checklist::STATUS[:unknown], Checklist.new(:is_draft=>false).status   This is actually unreachable
    pending
    Recommendation.delete_all

    @checklist.is_draft=true
    @checklist.user_id=2
    @checklist.student_id=1
    assert_equal Checklist::STATUS[:draft], @checklist.status
    assert @checklist.deletable


    @checklist=Checklist.find(:first)
    @checklist.is_draft=false
    @checklist.recommendation=nil
    assert_equal Checklist::STATUS[:missing_rec], @checklist.status
    assert @checklist.deletable
    assert @checklist.needs_recommendation

    @checklist=Checklist.find(:first)
    @checklist.is_draft=false
    @checklist.build_recommendation(:recommendation=>5,:should_advance=>true)

    assert_equal Checklist::STATUS[:cannot_refer], @checklist.status
    assert !@checklist.deletable
    assert !@checklist.needs_recommendation
   
    @checklist.promoted=true
    assert_equal Checklist::STATUS[:can_refer], @checklist.status
    assert !@checklist.deletable
    assert !@checklist.needs_recommendation

    @checklist.build_recommendation(:recommendation=>5,:should_advance=>false)
    assert_equal Checklist::STATUS[:ineligable_to_refer], @checklist.status


    @checklist.build_recommendation(:recommendation=>4,:should_advance=>false)
    assert_equal Checklist::STATUS[:nonadvancing], @checklist.status


    @checklist.build_recommendation(:recommendation=>4,:should_advance=>true)
    assert_equal Checklist::STATUS[:passed] % 1, @checklist.status

    @checklist.promoted=false
    assert_equal Checklist::STATUS[:failing_score], @checklist.status
  end

  describe 'checklist_definition_cache' do
    it 'should have specs see #193 and #194 in Lighthouse' do
      pending
    end
  end


  describe 'max_tier' do
    it 'should return nil when there are no checklists' do
      Checklist.max_tier.should be_nil
    end
    
    it 'should return the tier of the highest promoted checklist' do
      pending
    end
  end
end
