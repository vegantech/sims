class District::StudentsController < ApplicationController
  # GET /district_students
  # GET /district_students.xml
  def index
    @students = current_district.students.paged_by_last_name(params[:last_name],params[:page])
    redirect_to(district_students_url(:last_name => params[:last_name], :page => @students.total_pages)) and return if wp_out_of_bounds?(@students)
    capture_paged_controller_params
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /district_students/new
  # GET /district_students/new.xml
  def new
    @student = Student.new
    @student.enrollments.build(:end_year => Date.today.year)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /district_students/1/edit
  def edit
    @student = current_district.students.find(params[:id])
    @student.enrollments.build(:end_year => Date.today.year) if @student.enrollments.empty?
  end

  # POST /district_students
  # POST /district_students.xml
  def create
    @student = current_district.students.build(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = "#{edit_obj_link(@student)} was successfully created.".html_safe
        format.html { redirect_to(index_url_with_page) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /district_students/1
  # PUT /district_students/1.xml
  def update
    params[:student][:existing_system_flag_attributes] ||= {}
    @student = current_district.students.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = "#{edit_obj_link(@student)} was successfully updated.".html_safe
        format.html { redirect_to(index_url_with_page) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /district_students/1
  # DELETE /district_students/1.xml
  def destroy
    @student = current_district.students.find(params[:id])
    @student.remove_from_district

    respond_to do |format|
      format.html { redirect_to(index_url_with_page) }
    end
  end

  def check_id_state
    @student = Student.find_by_id_state(params['student']['id_state']) if params['student']['id_state'].present?

    render :update do |page|
      if @student
        if  current_district.can_claim?(@student.district)
          page.alert('Follow the link if you want to try to claim this student for your district')
          page.replace_html(:claim_student, link_to("Claim #{@student} for your district", :action=>'claim', :id => @student.id , :method => :put))
        else
          page.alert("Student exists in #{@student.district}  You may have mistyped the id, or the other district has not yet removed this student.")
        end
      end
    end
  end

  def claim
    @student = Student.find(params[:id])
     res,msg= current_district.claim(@student)
       flash[:notice] = msg.html_safe
     if res
       redirect_to edit_district_student_url(@student)
     else
       redirect_to :back
     end
  end

end
