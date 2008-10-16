class TimeLength < ActiveRecord::Base
  def self.TimeLengths
    @@TimeLengths ||= [TimeLength.create(:title=>:day, :days=>1)]
  end
end
