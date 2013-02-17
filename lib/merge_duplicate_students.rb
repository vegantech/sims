class MergeDuplicateStudents
  def self.by_id_state
    manual = []
    used = []

    dups= Student.group(:id_state).having("count(id) > 1").where("id_state is not null").pluck(:id_state)
    dups.each do |dup_id_state|
      #make sure content is the same
      if Student.where(:id_state => dup_id_state).select("distinct district_id, first_name, last_name, district_student_id").one?
         if Student.where(:id_state => dup_id_state).with_sims_content.exists?
           used << dup_id_state
           #move sims content
         else
           safe_destroy Student.where(:id_state => dup_id_state).pluck(:id)
         end

        #  keeper= Student.where(:id_state => dup_id_state).first
        #  others
        # move/merge content
        # remove all but one
      else
        manual << dup_id_state
      end
    end
    return manual,used

  end

  def self.safe_destroy(ids)
    sids = ids.dup
    keep = sids.shift
    Student.where(:id => sids).each(&:safe_destroy)
  end

end
