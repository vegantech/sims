class SpellCheckController < ApplicationController
  skip_before_filter :authenticate, :authorize, :verify_authenticity_token

  def index
    render :xml => noxspell(request.raw_post)
  end


  private

  def noxspell(text)
    x=spell_check(get_text(text))

    res = '<?xml version="1.0"?>' + "\n" 
    if x.blank?
      res +=  '<spellresult error="0"></spellresult>'
    else
      res += '<spellresult error="1">'
      res += x.join("\t")
      res += '</spellresult>'
    end

    res
  end
  def get_text(text)
    text.match(/<text>((.|\s)*?)<\/text>/)[0].sub(/\n/,' ')[6..-8]
  end

  def spell_check(text)
    command = "aspell -a -d en --encoding=utf-8 --sug-mode=normal"
    output = IO.popen(command, 'r+') {|io| io.puts(text); io.close_write; io.read }
    output.split("\n").collect {|line| parse_aspell_line(line) }.compact
  end

  def parse_aspell_line(line)
     if line.match(/^&/)
       offset = line.split(':')[0].split(" ").last
       len = line.split(':')[0].split(" ")[1].length
       
       %Q{<c o="#{offset}" l="#{len}" s="1">} +
       line.split(':',2)[1].split(",").collect(&:strip).join("\t") +
       '</c>'
       
     end
  end
end
