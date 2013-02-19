class MergeDuplicateStudents
  def self.by_id_state
    manual = []
    used = []

    dups= Student.group(:id_state).having("count(id) > 1").where("id_state is not null").pluck(:id_state)
    dups.each do |dup_id_state|
      #make sure content is the same
      if Student.where(:id_state => dup_id_state).select("distinct district_id, first_name, last_name, district_student_id").one?
        ids = Student.where(:id_state => dup_id_state).pluck(:id)
        merge_to_first(ids)
        safe_destroy_except_first(ids)
      else
        manual << dup_id_state
      end
    end
    return manual,used

  end

  def self.safe_destroy_except_first(ids)
    sids = ids.dup
    keep = sids.shift
    Student.where(:id => sids).each(&:safe_destroy)
  end

  def self.merge_to_first(ids)
    #make all custom content belong to the first student
    Student::CUSTOM_CONTENT.each do |a|
      puts a
      Student.reflect_on_association(a.to_sym).klass.update_all(["student_id =?", ids.first],:student_id => ids)
    end
    Student.find(ids.first).touch
  end

end
