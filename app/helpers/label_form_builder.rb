class LabelFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
    %w{date_select datetime_select time_select} +
    %w{collection_select select country_select time_zone_select} -
    %w{hidden_field label fields_for check_box } # Don't decorate these

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.extract_options!
      label = label(field, options[:label], :class => options[:label_class])
      help = options[:help]? ' '+@template.help_popup(options[:help]) : ''
      @template.content_tag(:div, label  + super + help, :class => 'form_row')  #wrap with a div form_Row
    end
  end

  def check_box(field,*args)
    options = args.extract_options!
    label = @template.content_tag(:b,label(field, options[:label], :class => options[:label_class]))
    help = options[:help]? ' ' +@template.help_popup(options[:help]) : ''
    @template.content_tag(:div, '' + super + label + help, :class => 'form_row')  #wrap with a div form_Row
  end

end
