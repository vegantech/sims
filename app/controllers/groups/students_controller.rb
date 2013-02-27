class Groups::StudentsController < Groups::AssignmentsController
  def new
    @student = Student.new
    @students=current_school.students.order('last_name, first_name') - @group.students
    respond_to do |format|
      format.js {}
    end
   end

  # POST /groups
  def create
    @student = current_school.students.find(params[:student][:id])
    @group.student_ids |= [@student.id]
  end

  # DELETE /groups/1
  def destroy
    @student = @group.students.find(params[:id])
    @group.students.delete(@student)
    respond_to do |format|
      format.js {}
    end
  end
end
