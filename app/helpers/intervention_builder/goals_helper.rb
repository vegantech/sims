module InterventionBuilder::GoalsHelper
  def move_up_down_buttons obj
    a=move_button(:up, obj) + "<br />" + move_button(:down, obj)
  end

  def move_button direction,obj
    form_remote_tag(:url=>
      move_path(obj, direction),
      :html=>{:style=>"display:inline"},:method=>:put) +
      hidden_field_tag("_method", "put") +
      image_submit_tag("arrow-#{direction}.gif") +
      "</form>"
  end


end
