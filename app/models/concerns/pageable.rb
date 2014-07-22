module Pageable
  extend ActiveSupport::Concern
  module ClassMethods
    def paged_by_last_name(last_name="", page="1")
      paged_by "last_name", last_name, page
    end

    def paged_by_title(title="", page="1")
      paged_by "title", title, page
    end

    private
    def paged_by col, val, page
      paginate :per_page => 25, :page => page,
               :conditions=> ["#{col} like ?", "%#{val}%"],
               :order => col
    end
  end
end
