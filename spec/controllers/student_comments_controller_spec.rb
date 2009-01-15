require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentCommentsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  def mock_student_comment(stubs={})
    @mock_student_comment ||= mock_model(StudentComment, stubs)
  end

  def mock_student(stubs={})
    @mock_student ||= mock_model(Student,stubs)
  end
  
  describe "responding to GET new" do
  
    it "should expose a new student_comment as @student_comment" do
      StudentComment.should_receive(:new).and_return(mock_student_comment)
      get :new
      assigns[:student_comment].should equal(mock_student_comment)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested student_comment as @student_comment" do
      controller.stub_association!(:current_user, :student_comments=>StudentComment)
      
      StudentComment.should_receive(:find).with("37").and_return(mock_student_comment)
      get :edit, :id => "37"
      assigns[:student_comment].should equal(mock_student_comment)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created student_comment as @student_comment" do
        StudentComment.should_receive(:new).with({'these' => 'params'}).and_return(mock_student_comment(:save => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        post :create, :student_comment => {:these => 'params'}
        assigns(:student_comment).should equal(mock_student_comment)
      end

      it "should redirect to the created student_comment" do
        StudentComment.stub!(:new).and_return(mock_student_comment(:save => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        post :create, {:student_comment => {}}, :selected_student_ids=>[1]
        response.should redirect_to(student_url(1))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved student_comment as @student_comment" do
        StudentComment.stub!(:new).with({'these' => 'params'}).and_return(mock_student_comment(:save => false))
        post :create, :student_comment => {:these => 'params'}
        assigns(:student_comment).should equal(mock_student_comment)
      end

      it "should re-render the 'new' template" do
        StudentComment.stub!(:new).and_return(mock_student_comment(:save => false))
        post :create, :student_comment => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do
    before do
      controller.stub_association!(:current_user, :student_comments=>StudentComment)
    end

    describe "with valid params" do

      it "should update the requested student_comment" do
        StudentComment.should_receive(:find).with("37").and_return(mock_student_comment)
        mock_student_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :student_comment => {:these => 'params'}
      end

      it "should expose the requested student_comment as @student_comment" do
        StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        put :update, :id => "1"
        assigns(:student_comment).should equal(mock_student_comment)
      end

      it "should redirect to the student_comment" do
        StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => true))
        controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
        put :update, {:id => "37"}, {:selected_students=>[1]}
        response.should redirect_to(student_url(1))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested student_comment" do
        StudentComment.should_receive(:find).with("37").and_return(mock_student_comment)
        mock_student_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :student_comment => {:these => 'params'}
      end

      it "should expose the student_comment as @student_comment" do
        StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => false))
        put :update, :id => "1"
        assigns(:student_comment).should equal(mock_student_comment)
      end

      it "should re-render the 'edit' template" do
        StudentComment.stub!(:find).and_return(mock_student_comment(:update_attributes => false))
        put :update, :id => "1"
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
      controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
      delete :destroy, {:id => "37"}, {:selected_students=>[1]}
    end
  
    it "should redirect to the student_comments list" do
      StudentComment.stub!(:find).and_return(mock_student_comment(:destroy => true))
      controller.should_receive(:current_student).and_return(mock_student(:id=>1, 'new_record?'=>false))
      delete :destroy, {:id => "37"}, {:selected_students=>[1]}
      response.should redirect_to(student_url(1))
    end

  end

end
