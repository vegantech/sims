require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BreadcrumbsHelper do
  describe 'breadcrumbs' do
    it 'should show them joined with ->' do
      helper.stub!(root_crumb: "root")
      helper.stub!(school_crumb: 'school')
      helper.stub!(search_crumb: 'search')
      helper.stub!(students_crumb: 'students')
      helper.stub!(current_student_crumb: 'current_student')
      helper.breadcrumbs.should == "root -> school -> search -> students -> current_student"
    end

    it 'should skip missing ones' do
      helper.stub!(root_crumb: "root")
      helper.stub!(school_crumb: nil)
      helper.stub!(search_crumb: nil)
      helper.stub!(students_crumb: nil)
      helper.stub!(current_student_crumb: 'current_student')
      helper.breadcrumbs.should == "root -> current_student"
    end
  end

  describe 'private methods' do
    subject {helper}
    its(:root_crumb) { should == link_to("Home",root_path)}
    its(:school_crumb) { should == nil}

    describe 'with school in session' do
      before {session[:school_id] = 2}
      its(:school_crumb) { should == link_to("School Selection",schools_path)}
    end

    its(:search_crumb){should be_nil}
    its(:students_crumb){should be_nil}

    describe 'with search in session' do
      let!(:current_school){mock_school}
      before do
        session[:search] = {}
        helper.stub!(current_school: current_school)
      end
      its(:search_crumb){should == link_to("Student Search",school_student_search_path(current_school))}
      its(:students_crumb){should == link_to("Student Selection", students_path)}
    end

    #
    #test current student present, missing, and new record
    describe 'current_student_crumb' do
      it 'with nil student' do
        helper.stub!(current_student: nil)
        helper.send(:current_student_crumb).should be_nil
      end

      it 'with new student' do
        helper.stub!(current_student: Student.new)
        helper.send(:current_student_crumb).should be_nil
      end

      it 'with a student' do
        ms = mock_student
        helper.stub!(current_student: ms)
        helper.send(:current_student_crumb).should == link_to(ms,student_path(ms))
      end
    end
  end
end
