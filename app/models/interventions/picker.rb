class Interventions::Picker

  def initialize(parent, opts)
    @parent = parent
    @opts = opts
    @object_id = @opts[object_id_field]
  end

  def id
    object.try(:id)
  end

  def object
    @object ||= find_or_only dropdowns, @object_id
  end

  def find_or_only(arr,arr_id)
    arr.detect{|a| a.id == arr_id.to_i} || first_if_only(arr)
  end

  def first_if_only(arr)
    arr.first if arr.one?
  end

  def blank?
    dropdowns.blank?
  end
end
