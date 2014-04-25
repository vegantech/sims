class SpellCheckController < ApplicationController
  skip_before_filter :authenticate_user!, :authorize, :verify_authenticity_token


  include ActionView::Helpers::SanitizeHelper
  extend ActionView::Helpers::SanitizeHelper::ClassMethods

  def check_spelling
    require 'cgi'
    require 'fckeditor_spell_check'
    @words = []

    @original_texts = params[:textinputs] || []


    @original_texts.each_with_index do |box, idx|
      plain_text = strip_tags(CGI.unescape(box))
      @words[idx] = FckeditorSpellCheck.check_spelling(plain_text)
    end

    render layout: false
  end
end
