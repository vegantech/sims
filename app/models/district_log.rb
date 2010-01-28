class DistrictLog < ActiveRecord::Base
  belongs_to :district

  def to_s
    "#{created_at}- #{body}"
  end
end
