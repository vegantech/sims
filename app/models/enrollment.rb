class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :school

	def self.search search_hash
		if search_hash and search_hash[:school_id]
			enrollments = School.find(search_hash[:school_id]).enrollments(:include => :students)
			if search_hash[:grade] and search_hash[:grade] != '*'
				enrollments = enrollments.select{|e| e.grade == search_hash[:grade]}
			end

			if search_hash[:last_name] and ! search_hash[:last_name].empty?
				enrollments = enrollments.select{|e| e.student.last_name =~ /^#{search_hash[:last_name]}/i}
			end

			enrollments
		else
			[]
		end
	end
end
