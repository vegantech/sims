require 'erb'
require 'active_support/core_ext/kernel/singleton_class'

class ERB
  module Util
    #TODO remove this when switching to rails 3.2+
    # A utility method for escaping HTML tag characters.
    # This method is also aliased as <tt>h</tt>.
    #
    # In your ERB templates, use this method to escape any unsafe content. For example:
    #   <%=h @person.name %>
    #
    # ==== Example:
    #   puts html_escape("is a > 0 & a < 10?")
    #   # => is a &gt; 0 &amp; a &lt; 10?
    def html_escape(s)
      s = s.to_s
      if s.html_safe?
        s
      else
        silence_warnings do
          s.gsub(/[&"'><]/n) { |special| HTML_ESCAPE[special] }.html_safe
        end
      end
    end

    remove_method(:h)
    alias h html_escape

    module_function :h

    singleton_class.send(:remove_method, :html_escape)
    module_function :html_escape
 end
end

class String
  def html_safe
    ActiveSupport::SafeBuffer.new(self)
  end
end
