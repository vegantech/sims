class SystemFlag < Flag
  validates_uniqueness_of :category, :scope=>:student_id
end
