require 'test/unit'
require 'google_spell'
# Re-raise errors caught by the controller.
class GoogleSpell; def rescue_action(e) raise e end; end


class GoogleSpellTest < Test::Unit::TestCase
  def setup
    begin
      a=Socket.gethostbyname("www.google.com")
    rescue SocketError
      puts "Cannot find IP for www.google.com  You need to be connected to the Internet to run this test (and to use spell check if aspell is not installed)"
      puts "alternatavely you can set the GOOGLE_OFFLINE env variable and this test will be simulated"
      puts "on win this is set GOOGLE_OFFLINE=true && ruby google_spelltest.rb "

      exit
    end

  end

  def test_GetWords
    assert GoogleSpell.GetWords("dog").first["data"].empty?, "dog is spelled correctly no data returned"
    assert GoogleSpell.GetWords("dogz bad dlfkslfsfjskldfjelfdshfsdkjhfdskjfh").first["data"].split("\t").include?("dog"), "dogz not a correctly spelled word,      should include dog in the returned data"
  end


end
