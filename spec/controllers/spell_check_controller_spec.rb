require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SpellCheckController do

  #Delete these examples and add some real ones
  it "should use ScriptedController" do
    controller.should be_an_instance_of(SpellCheckController)
  end


  describe "GET 'field with spellign mistakes'" do
    it "should be successful" do
      incorrect="<?xml version=\"1.0\" encoding=\"utf-8\" ?><spellrequest textalreadyclipped=\"0\" ignoredups=\"0\" ignoredigits=\"1\" ignoreallcaps=\"1\"><text>wrng wrongid</text></spellrequest>"
      request.stub!(:raw_post => incorrect)
      post 'index'

      response.body.should == "<?xml version=\"1.0\"?>\n<spellresult error=\"1\"><c o=\"0\" l=\"4\" s=\"1\">wrong\twrung\twring\tWang\tWong</c>\t<c o=\"5\" l=\"7\" s=\"1\">wrong id\twrong-id\twronged\twrongs\twrong\twronging\tranged\tpronged\twronger\twrongdoer\twrongly\trigid\tringgit\twrongest\tringed\ttonged\treneged\trinked\twrung\twrangled\trouged\tRonald\tbonged\tdonged\tgonged\tlonged\tponged\trancid\tranked\tthronged\tpranged</c></spellresult>"
    end
  end

  describe "GET 'field without any spelling errors'" do
    it "should be successful" do
      correct="<?xml version=\"1.0\" encoding=\"utf-8\" ?><spellrequest textalreadyclipped=\"0\" ignoredups=\"0\" ignoredigits=\"1\" ignoreallcaps=\"1\"><text>wrong</text></spellrequest>"
      request.stub!(:raw_post => correct)
      post 'index'
      response.body.should == "<?xml version=\"1.0\"?>\n<spellresult error=\"0\"></spellresult>"
    end
  end
end
