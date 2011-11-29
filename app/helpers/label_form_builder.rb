class LabelFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
    %w{date_select datetime_select time_select} +
    %w{collection_select select country_select time_zone_select} -
    %w{hidden_field label fields_for check_box } # Don't decorate these

  attr_accessor :spell_check_fields
  to_spell_check = %w{ text_area }

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      label = label(field, options[:label], :class => options[:label_class])
      if to_spell_check.include?(name)
        options[:class] = "#{options[:class]} spell_check"
        sp = @template.instance_variable_get('@spell_check_fields') || []
        sp <<  label.split("for=",2)[1].split('"')[1] 
        @template.instance_variable_set('@spell_check_fields', sp)
      end

      help = options[:help]? ' '+@template.help_popup(options[:help]) : ''
      remove_link = ' ' + (options[:remove_link] || '')
      @template.content_tag(:div, label  + super + help + remove_link, :class => 'form_row')  #wrap with a div form_Row
    end
  end

  def check_box(field,*args)
    options = args.extract_options!
    label = @template.content_tag(:b,label(field, options[:label], :class => options[:label_class]))
    help = options[:help]? ' ' +@template.help_popup(options[:help]) : ''
    @template.content_tag(:div, '' +  label + help + super, :class => 'form_row')  #wrap with a div form_Row
  end


end
