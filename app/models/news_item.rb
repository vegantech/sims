class NewsItem < ActiveRecord::Base
  belongs_to :country
  belongs_to :state
  belongs_to :district
  belongs_to :school

  named_scope :system, :conditins=>{:system=>true}
end
