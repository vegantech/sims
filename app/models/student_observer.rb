class StudentObserver < ActiveRecord::Observer
  def after_create(student)
    student.historical_enrollments.create!(:district => student.district, :start_date => Date.today)
  end

  def after_update(student)
    return false unless student.district_id_changed?
    student.historical_enrollments.update_all(:end_date=>Date.today)
  end
end
