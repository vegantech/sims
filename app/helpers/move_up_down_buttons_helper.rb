module MoveUpDownButtonsHelper
  def move_up_down_buttons obj
    a=(move_button(:up, obj) + "<br />".html_safe + move_button(:down, obj)).html_safe
  end

  def move_button direction,obj
    (form_remote_tag(:url=>
      move_path(obj, direction),
      :html=>{:style=>"display:inline"},:method=>:put) +
      hidden_field_tag("_method", "put") +
      image_submit_tag("arrow-#{direction}.gif") +
      "</form>".html_safe).html_safe
  end


end
