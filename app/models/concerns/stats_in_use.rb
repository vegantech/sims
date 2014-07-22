module StatsInUse
  extend ActiveSupport::Concern
  module ClassMethods
    #combined
    def stats_in_use(filters={})
      calc_start_date = filters[:created_after] || "2000-01-01".to_date
      calc_end_date = filters[:created_before] || "2100-01-01".to_date
      date_conditions = {:created_at => calc_start_date..calc_end_date}
      k= stats_in_use_joins(stats_in_use_union(date_conditions))
      k=k.where(["district_id != ?", filters[:without]]) if filters[:without]
      k
    end

    protected
    def stats_in_use_union(date_conditions)
      stats_in_use_classes.collect { |u|
        #horrible hack, but it works for now as the Student Studnt Comments association is just comments
        f_key=reflect_on_association(u.name.tableize.to_sym).try(:foreign_key) || "student_id"
        u.select("#{f_key} as f_key_id").where(date_conditions).to_sql
      }.join(" UNION ")
    end

    def stats_in_use_classes
      [ Intervention,StudentComment,TeamConsultation ]
    end

    def stats_in_use_joins(union)
      joins("inner join (#{union}) e on #{name.tableize}.id=e.f_key_id")
    end
  end
end
