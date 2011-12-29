require 'action_view/helpers/form_helper'
module ActionView
  module Helpers
    def apply_form_for_options!(object_or_array, options) #:nodoc:
      object = object_or_array.is_a?(Array) ? object_or_array.last : object_or_array

      html_options =
        if object.respond_to?(:new_record?) && object.new_record?
          { :class  => dom_class(object, :new),  :id => dom_id(object), :method => :post }
        else 
          { :class  => dom_class(object, :edit), :id => dom_id(object, :edit), :method => :put }
        end  

      options[:html] ||= {}
      options[:html].reverse_merge!(html_options)
      options[:url] ||= polymorphic_path(object_or_array, :format=>options[:format])
    end  
  end
end

