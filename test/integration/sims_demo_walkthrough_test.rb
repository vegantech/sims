require 'test_helper'

# This is a representation of a yet to be created SIMS DEMONSTRATION SCRIPT or webcast


class SimsDemoWalkthroughTest < ActionController::IntegrationTest
   ONESCHOOL = {
    :username=>"oneschool",
    :password=>"oneschool"
  }
 # fixtures :your, :models
  def test_demo
    oneschool_test
  end
  
  def oneschool_test
    oneschool = regular_user
    oneschool.logs_in ONESCHOOL
    oneschool.is_viewing "main/index"
    oneschool.sees "School Selection"
    oneschool.chooses_school_selection
    oneschool.is_viewing "schools/index"
    oneschool.sees "Alpha Elementary"
    oneschool.chooses_school
    oneschool.is_viewing "students/search"
    oneschool.searches_all_students
    oneschool.is_viewing "students/index"
    oneschool.sees "Alpha_First"
    oneschool.sees "Alpha_Third"
    oneschool.selects_all_students
    oneschool.sees "Student 1 of 2"
    oneschool.chooses_other_student
    oneschool.sees "Student 2 of 2"
  end




  def regular_user
    open_session do |user|
      def user.logs_in(user)
        post_via_redirect "/login/login", user
      end

      def user.chooses_school_selection
        get "/schools"
      end

      def user.chooses_school
        post_via_redirect "/schools/select", :school=>{:id=>School.first.id}
      end
      
      def user.searches_all_students
        post_via_redirect "/students/search", :students=>{:grade=>"*"}
      end
  
      def user.selects_all_students
        post_via_redirect "/students/select", "id"=>[students(:alpha_first_grader).id,students(:alpha_third_grader).id]
      end

      def user.chooses_other_student
        get "/students/#{students(:alpha_third_grader).id}"
      end


      def user.sees(mystring)
        assert_match /#{mystring}/, response.body
      end

      def user.is_viewing(page)
        assert_response :success, response.body
        assert_template page, response.body
      end

      def user.does_not_see(string)
        assert !response.body.include?( string ) ,  "#{response.body} had #{string} but should not have."
      end
    end
  end













end


