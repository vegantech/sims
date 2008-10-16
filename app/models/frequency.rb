class Frequency < ActiveRecord::Base
  def self.Frequencies
    @@Frequencies ||=  [Frequency.create(:title=>:day)]

  end
end
