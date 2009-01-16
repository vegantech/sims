module SpellCheck
  include ActionView::Helpers::TextHelper
  ASPELL_WORD_SUGGEST_REGEX = Regexp.new(/\s\w+,(.*)$/)
  ASPELL_PATH = "aspell"
  def suggestions
    @suggestions = check_spelling(params[:word], "suggest")
    render(:partial=>'spell_check/suggestions' )#,:layout=>false)
  end



private
  def spellcheck (comment)
    errors = ''
    unless comment.blank?
      spelling_errors = check_spelling(comment, "spell")
      @spelling_errors = spelling_errors
      flash[:notice] ="Spell Check completed: Found #{pluralize(@spelling_errors.size, 'error' )}."
    end
  end



  def check_spelling(comment, command)
    lang = "en"
    comment2=comment.gsub(/[^\w' ]/," ")
    @spell_check_response = `echo "#{comment2}" | #{ASPELL_PATH} -a -l #{lang}`

    @spell = Array.new
    @suggestions = Array.new
    if (@spell_check_response != '')
      if (command == 'spell')
        errors = @spell_check_response.split('&')
        errors.each {|e|
          if e.include?(":")
            word = e.split(': ')[0].split(" ")[0]
            @spell << word
          end
        }
        return @spell
      elsif (command == 'suggest')
        if (match_data = @spell_check_response.match(ASPELL_WORD_SUGGEST_REGEX
          ))
          @suggestions = match_data[0].strip.split(', ')
        end
      end
    else #Try google
      if (command == 'spell')
        @spell=GoogleSpell.GetWords(comment2).collect{|k| k["original"] unless k["data"].empty?}.compact
        return @spell
      elsif (command == 'suggest')
        @suggestions=GoogleSpell.GetWords(comment2).first["data"].split("\t")
      end



    end
    @suggestions
  end
end
