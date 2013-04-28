class Interventions::Picker

  def find_or_only(arr,arr_id)
    arr.detect{|a| a.id == arr_id} || first_if_only(arr)
  end

  def first_if_only(arr)
    arr.first if arr.one?
  end

end
