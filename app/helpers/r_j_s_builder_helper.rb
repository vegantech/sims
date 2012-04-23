module RJSBuilderHelper

  BLIND_DOWN_TIME = 0.25
  BLIND_UP_TIME = 0.25
  # Below are our standard JS helpers
  # It's used mostly in the checklist builder

  # When you have links that are highlighted, if they are clicked in quick succession the
  # start color becomes whatever the current color of the highlight is, and therefore the
  # end color.  This prevents this behavior.
  def safe_highlight(dom_id)
    page << "if(!Element.hasClassName('#{dom_id}','disabled_for_highlight')){"
    page << "Element.addClassName('#{dom_id}','disabled_for_highlight')"
    page.visual_effect :highlight, "#{dom_id}"
    page.delay(1) do
      page << "Element.removeClassName('#{dom_id}','disabled_for_highlight')"
    end
    page << "}"
  end

  # Returns the javascript necessary to check for visibility.
  def if_visible(dom_id)
    "if (Element.visible('#{dom_id}')){"
  end

  # Returns the javascript necessary to check if an element is not visible.
  def if_not_visible(dom_id)
    "if (!Element.visible('#{dom_id}')){"
  end

  # Changes the content of a link and safely highlights it.  Remember to use a span in the link
  # for the "drifting" theme.
  def change_link(dom_id, new_text)
    page.update_content(dom_id, new_text)
  end

  # Replaces the partial with an updated copy and highlights it to reflect the change
  def update_content(dom_id, *options_for_render)
    page.replace_html dom_id, *options_for_render
    page.safe_highlight dom_id
  end

  # Inserts content into the given dom_id then blinds_down
  def insert_content(dom_id, *options_for_render)
    page.replace_html dom_id, *options_for_render
    page.blind_down dom_id
  end

  # Blinds up and removes the content
  def remove_content(dom_id, options={})
    options[:duration] ||= BLIND_UP_TIME
    page.blind_up dom_id, options
    page.delay(options[:duration]) do
      page.replace_html dom_id, ""
    end
  end

  # Does blind_down with standard options
  def blind_down(dom_id, options={})
    options[:duration] ||= BLIND_DOWN_TIME
    page.visual_effect :blind_down, dom_id, options
  end

  # Does blind_up with standard options
  def blind_up(dom_id, options={})
    options[:duration] ||= BLIND_UP_TIME
    page.visual_effect :blind_up, dom_id, options
  end

  # Removes the content if it is visible
  def remove_content_if_visible(dom_id)
    page << if_visible(dom_id)
    page.remove_content dom_id
    page << "}"
  end

  # Removes the content and changes the link if the content is visible
  def remove_content_and_change_link_if_visible(content_dom_id, link_dom_id, link_text)
    page << if_visible(content_dom_id)
    page.remove_content content_dom_id
    page.change_link link_dom_id, link_text
    page << "}"
  end

  # Inserts or updates error content
  def insert_or_update_error_content(dom_id, error_messages)
    page << if_visible(dom_id)
    page.update_content dom_id, error_messages
    page << "}else{"
    page.insert_content dom_id, error_messages
    page << "}"
  end

  def set_flash_notice(page)
    page.replace_html "flash_notice", flash[:notice].to_s
    flash.discard
  end

end
