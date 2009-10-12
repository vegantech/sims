class ExtArbitrary < ActiveRecord::Base
  belongs_to :student

  def to_s
    content
  end
end
