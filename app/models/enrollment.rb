class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :school

	def self.search search_hash
		# enrollments = School.find(search_hash[:school_id]).enrollments(:include=>:students)
		# params[:students] ||= {}
		# selected_grade = params[:students][:grade]
		# if selected_grade and selected_grade != '*'
		# enrollments = enrollments.select{|e| e.grade == selected_grade}
		# end

		# @students = enrollments
		if search_hash and search_hash[:school_id]
			enrollments = School.find(search_hash[:school_id]).enrollments(:include => :students)
			if search_hash[:grade] and search_hash[:grade] != '*'
				enrollments = enrollments.select{|e| e.grade == search_hash[:grade]}
			end
			enrollments
		else
			[]
		end
	end
end
