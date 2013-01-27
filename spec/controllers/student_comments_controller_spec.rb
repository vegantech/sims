require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentCommentsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  def mock_student_comment(stubs={})
    @mock_student_comment ||= mock_model(StudentComment, stubs)
  end

  def mock_student(stubs={})
    @mock_student ||= mock_model(Student,stubs)
  end

  describe "with authorized student" do
    before do
      @s=mock_student(:comments => StudentComment)
      @u=mock_user(:student_comments=>StudentComment, :id=>999)
      controller.should_receive(:current_user).at_least(:once).and_return(@u)
      @s.should_receive(:belongs_to_user?).with(@u).and_return(true)
      Student.should_receive(:find_by_id).with("2").and_return(@s)

    end
    describe "responding to GET new" do

      it "should expose a new student_comment as @student_comment" do

        StudentComment.should_receive(:build).and_return(mock_student_comment)
        get :new,:student_id => "2"
        assigns(:student_comment).should equal(mock_student_comment)
      end

    end

    describe "responding to GET edit" do

      it "should expose the requested student_comment as @student_comment" do
        controller.stub_association!(:current_user, :student_comments=>StudentComment)

        StudentComment.should_receive(:find).with("37").and_return(mock_student_comment)
        get :edit, :id => "37",:student_id => "2"
        assigns(:student_comment).should equal(mock_student_comment)
      end

    end

    describe "responding to POST create" do

      describe "with valid params" do

        it "should expose a newly created student_comment as @student_comment" do
          StudentComment.should_receive(:build).with({'these' => 'params'}).and_return(mc=mock_student_comment(:save => true))
          mc.should_receive(:user=)
          #controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
          post :create, :student_comment => {:these => 'params'},:student_id => "2"
          assigns(:student_comment).should equal(mock_student_comment)
        end

        it "should redirect to the created student_comment" do
          StudentComment.stub!(:build).and_return(mc=mock_student_comment(:save => true))
          mc.should_receive(:user=)

          post :create, {:student_comment => {},:student_id => "2"}, :selected_student_ids=>[1]
          flash[:notice].should ==('Team Note was successfully created.')
          response.should redirect_to(student_url(@s.id))
        end

      end

      describe "with invalid params" do

        it "should expose a newly created but unsaved student_comment as @student_comment" do
          StudentComment.stub!(:build).with('these' => 'params').and_return(mock_student_comment(:save => false, 'user=' => true))
          post :create, :student_comment => {:these => 'params'},:student_id => "2"
          assigns(:student_comment).should equal(mock_student_comment)
        end

        it "should re-render the 'new' template" do
          StudentComment.stub!(:build).and_return(mock_student_comment(:save => false, 'user=' => true))
          post :create, :student_comment => {},:student_id => "2"
          response.should render_template('new')
        end

      end

    end

    describe "responding to PUT udpate" do
      before do
        @mock_student = mock_student(:id=>1, 'new_record?'=>false)
        controller.stub_association!(:current_user, :student_comments=>StudentComment)
        controller.stub!(:current_student=>@mock_student)
      end

      describe "with valid params" do

        it "should update the requested student_comment" do
          StudentComment.should_receive(:find).with("37").and_return(mock_student_comment(:update_attributes=>true))
          put :update, :id => "37", :student_comment => {:body => 'params'},:student_id => "2"
        end

        it "should expose the requested student_comment as @student_comment" do
          StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => true))
          put :update, :id => "1", :student_comment => {:body => 'params'},:student_id => "2"
          assigns(:student_comment).should equal(mock_student_comment)
        end

        it "should redirect to the student" do
          StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => true))
          put :update, {:id => "37", :student_comment => {},:student_id => "2"}, {:selected_students=>[1]}
          response.should redirect_to(student_url(@mock_student))
        end

      end

      describe "with invalid params" do

        it "should expose the student_comment as @student_comment" do
          StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => false))
          put :update, :id => "1", :student_comment => {:body => 'params'},:student_id => "2"
          assigns(:student_comment).should equal(mock_student_comment)
        end

        it "should re-render the 'edit' template" do
          StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => false))
          put :update, :id => "1", :student_comment => {:body => 'params'},:student_id => "2"
          response.should render_template('edit')
        end

      end

    end

    describe "responding to DELETE destroy" do
      before do
        controller.stub_association!(:current_user, :student_comments=>StudentComment)
      end

      it "should destroy the requested student_comment" do
        StudentComment.should_receive(:find).with("37").and_return(mock_student_comment)
        mock_student_comment.should_receive(:destroy)
        #      controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        delete :destroy, {:id => "37",:student_id => "2"}, {:selected_students=>[1]}
      end

      it "should redirect to the student_comments list" do
        StudentComment.stub!(:find).and_return(mock_student_comment(:destroy => true))
        #      controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        delete :destroy, {:id => "37",:student_id => "2"}, {:selected_students=>[1]}
        response.should redirect_to(student_url(@mock_student))
      end

    end

  end
end
