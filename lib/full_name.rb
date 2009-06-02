module FullName
  def fullname
    [first_name, middle_initial, last_name, stripped_suffix].compact.join(' ')
  end

  def fullname_last_first
    last_name.to_s + ', ' + [first_name, middle_initial, stripped_suffix].compact.join(' ')
  end

  def middle_initial
    "#{middle_name.first}." if defined?(middle_name) && middle_name.present?
  end

  def stripped_suffix
    suffix.sub(/\.$/, '') if defined?(suffix) && suffix.present?
  end

  def to_s
    fullname
  end
end
