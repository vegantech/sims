require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentSearchesController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  let!(:school) {mock_school}

  describe 'private methods' do
    it 'should test the private methods' do
      pending
    end
    it 'should perform student search' do
      pending

      enrollments = mock_enrollment(:search => true)
      school = mock_school(:enrollments => enrollments)
      @user=mock_user(:authorized_enrollments_for_school=>enrollments)
      controller.should_receive(:current_user).at_least(:once).and_return(@user)
      controller.should_receive(:current_school).at_least(:once).and_return(school)
    end


    it 'should test setup_students_for_show' do
      pending
      controller.should_receive(:flags_above_threshold).and_return([])
    end

    it 'should test flags_above_threshold' do
      pending
      controller.should_receive(:current_district).and_return(District.new)

    end
  end


  describe 'show' do
    let(:user) {mock_user}
    describe 'GET' do
      before do
        controller.stub!(:current_school => school, :current_school_id => school.id, :current_user => user)
      end

      it 'should redirect with a flash when the school is empty' do
        school.should_receive(:grades_by_user).with(user).and_return([])
        school.should_receive(:students).and_return([])
        get :show, :school_id => school.id
        flash[:notice].should == "#{school} has no students enrolled."
        response.should redirect_to(schools_url)

      end

      it 'should redirect with a flash when there are no authorized students' do
        school.should_receive(:grades_by_user).with(user).and_return([])
        school.should_receive(:students).and_return([1])
        get :show, :school_id => school.id
        flash[:notice].should == "User doesn't have access to any students at #{school}."
        response.should redirect_to(schools_url)

      end

      it 'should set @grades and render search template' do
        school.should_receive(:enrollment_years).and_return([1,2,3])
        school.should_receive(:grades_by_user).with(user).and_return ['*','1','2']
        user.should_receive(:filtered_groups_by_school).with(school).and_return ['g1']
        user.should_receive(:filtered_members_by_school).with(school).and_return ['m1','m2']

        get :show, :school_id => school.id

        assigns(:grades).should == ['*', '1', '2']
        assigns(:users).should == ['m1', 'm2']
        assigns(:groups).should == ['g1']
        response.should render_template('search')
      end

      describe 'school mismatch' do
        before do
          controller.stub!(:current_school_id => nil)
          user.stub!(:schools => School)
        end
        it 'should redirect if the school is not authorized' do
          get :show, :school_id => -123
          response.should redirect_to(root_url)

        end

        it 'should set the school if the school is authorized' do
          School.should_receive(:find).with(school.id.to_s).and_return(school)
          school.should_receive(:grades_by_user).with(user).and_return([])
          school.should_receive(:students).and_return([])
          lambda {
            get :show, :school_id => school.id
          }.should change {session[:school_id]}.from(nil).to(school.id)
        end

      end
    end

    describe 'POST' do
      describe 'without search criteria' do
        it 'should set error message and redraw search screen' do
          post :create, :school_id => school.id
          flash[:notice].should == 'Missing search criteria'
          response.should redirect_to("http://test.host/schools/#{school.id}/student_search")
        end
      end

      describe 'with search criteria' do
        it 'should capture search criteria in session and redirect to students_url' do
          post :create, 'search_criteria' => {'grade' => '1', 'last_name' => 'Buckley', 'search_type' => 'Search Type'},
                        'flagged_intervention_types' => ['attendance', 'math'], :school_id => school.id

          response.should redirect_to(students_url)

          session[:search].should == {'flagged_intervention_types'=>['attendance', 'math'],
                                      'last_name'=>'Buckley', 'intervention_group_types'=>nil, 'grade'=>'1', 'search_type'=>'Search Type'}
        end
      end
    end
  end


  describe 'grade' do
    before do
      @user=mock_user
      controller.stub!(:current_user=>@user)
      controller.stub!(:current_school=>school)

    end
    describe 'passed *' do
      it 'should assign same value for @groups as student_groups and @users as group_users' do
        @user.should_receive(:filtered_members_by_school).with(school,{"grade"=>"*", "school_id" => school.id.to_s}).and_return([1,2,3,4])
        @user.should_receive(:filtered_groups_by_school).with(school,{"grade"=>"*", "school_id" => school.id.to_s}).and_return([5,6,7,8])

        xhr :post, :grade, :grade=>"*", :school_id => school.id
        assigns(:groups).should == [5,6,7,8]
        assigns(:users).should == [1,2,3,4]

      end
    end

    describe 'passed 01' do
      it 'should call filter student groups by grade and assign @groups and @users accordingly' do
        @user.should_receive(:filtered_groups_by_school).with(school,{"grade"=>'01', "school_id" => school.id.to_s}).and_return(['g1-1','g1-3'])
        @user.should_receive(:filtered_members_by_school).with(school,{"grade"=>'01', "school_id" => school.id.to_s}).and_return(['g1-6','g1-8'])

        xhr :post, :grade, :grade=>"01", :school_id => school.id
        assigns(:groups).should == ['g1-1','g1-3']
        assigns(:users).should == ['g1-6','g1-8']

      end

    end
  end

  describe 'member' do
    before do
      @user=mock_user
      controller.stub!(:current_user=>@user)
      controller.stub!(:current_school=>school)

    end
    describe 'passed * for grade and "" for user' do
      it 'should assign same value for @groups as student groups' do
        @user.should_receive(:filtered_groups_by_school).with(school,{"grade"=>'*',"user"=>"", "school_id" => school.id.to_s}).and_return([1,2,3,4])

        xhr :post, :member, :grade=>"*", :user=>"", :school_id => school.id
        assigns(:groups).should == [1,2,3,4]
      end
    end

    describe 'passed blank for user and 01 for grade' do
      it 'should call filter student groups by grade and assign @groups accordingly' do
        @user.should_receive(:filtered_groups_by_school).with(school,{"grade"=>'01',"user"=>"", "school_id" => school.id.to_s}).and_return([1,2,4])
        xhr :post, :member, :grade=>"01", :user=>"", :school_id => school.id
        assigns(:groups).should == [1,2,4]

      end

    end

    describe 'passed 5 for user and 01 for grade' do
      it 'should filter by both grade and user' do
        @user.should_receive(:filtered_groups_by_school).with(school,{"grade"=>'01',"user"=>"5", "school_id" => school.id.to_s}).and_return([2])
        xhr :post, :member, :grade=>"01", :user=>"5", :school_id => school.id
        assigns(:groups).should == [2]
      end

    end

  end

  #controller.should_receive(:group_users).and_return([])
  #     controller.should_receive(:student_groups).and_return([])
end
