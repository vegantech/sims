module MoveUpDownButtonsHelper
  def move_up_down_buttons obj
    move_button(:up, obj) +  tag("br") + move_button(:down, obj)
  end

  def move_button direction,obj
    form_tag(move_path(obj, direction), {:style => "display:inline",:method => :put, :remote => true}) do
      image_submit_tag("arrow-#{direction}.gif")
    end
  end
end
