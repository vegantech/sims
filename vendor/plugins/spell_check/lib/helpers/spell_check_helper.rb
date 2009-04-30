module SpellCheckHelper
  def spellcheck_submit prefix=nil
    spell_check_submit prefix
  end

  def spell_check_submit prefix=nil
    hidden_field_tag("spellcheck", nil, :id=>"#{prefix}spellcheck") + 
    submit_tag("Spellcheck", :name=>"spellcheck",:onclick =>"$('#{prefix}spellcheck').value='Spellcheck'")
  end

  def spellcheck_partial
    render(:partial=>"spell_check/spelling")
  end


end
