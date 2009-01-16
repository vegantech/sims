require File.dirname(__FILE__)+'/../../lib/google_spell'
if ENV['GOOGLE_OFFLINE']

  class GoogleSpell
      def self.GetWords(str)
        puts "Googlespell offline test"
        return [{"data"=>"dog"}] if str =~ /dogz/
        return [{"data"=>""}]
      end
  end
end
