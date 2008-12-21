class School::StudentsController < ApplicationController
  # GET /school_students
  # GET /school_students.xml
  def index
    @school_students = Student.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @school_students }
    end
  end

  # GET /school_students/1
  # GET /school_students/1.xml
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /school_students/new
  # GET /school_students/new.xml
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /school_students/1/edit
  def edit
    @student = Student.find(params[:id])
  end

  # POST /school_students
  # POST /school_students.xml
  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = 'School::Student was successfully created.'
        format.html { redirect_to(school_student_url(@student)) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /school_students/1
  # PUT /school_students/1.xml
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = 'School::Student was successfully updated.'
        format.html { redirect_to(school_student_url(@student)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /school_students/1
  # DELETE /school_students/1.xml
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(school_students_url) }
      format.xml  { head :ok }
    end
  end
end
