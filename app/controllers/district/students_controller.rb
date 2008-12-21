class District::StudentsController < ApplicationController
  # GET /district_students
  # GET /district_students.xml
  def index
    @students = current_district.students.paged_by_last_name(params[:last_name],params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @district_students }
    end
  end

  # GET /district_students/1
  # GET /district_students/1.xml
  def show
    @student = current_district.students.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /district_students/new
  # GET /district_students/new.xml
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /district_students/1/edit
  def edit
    @student = Student.find(params[:id])
  end

  # POST /district_students
  # POST /district_students.xml
  def create
    @student = current_district.students.build(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = 'District::Student was successfully created.'
        format.html { redirect_to(district_student_url(@student)) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /district_students/1
  # PUT /district_students/1.xml
  def update
    @student = current_district.students.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = 'District::Student was successfully updated.'
        format.html { redirect_to(district_student_url(@student)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /district_students/1
  # DELETE /district_students/1.xml
  def destroy
    @student = current_district.students.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(district_students_url) }
      format.xml  { head :ok }
    end
  end
end
