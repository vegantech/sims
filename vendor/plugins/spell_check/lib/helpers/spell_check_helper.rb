module SpellCheckHelper
  def spellcheck_submit
    submit_tag "Spellcheck", :name=>"spellcheck"

  end

  def spellcheck_partial
    render(:partial=>"spell_check/spelling")
  end


end
