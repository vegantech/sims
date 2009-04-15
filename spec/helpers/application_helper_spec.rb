require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ApplicationHelper)
  end

  it 'should convert true and false to yes or no using yes_or_no' do
    helper.yes_or_no(true).should == "Yes"
    helper.yes_or_no(false).should == "No"
  end

  it 'should have a spinner with optional suffix' do
    helper.spinner.should match(/spinner.gif.*display:none/)
    helper.spinner("suffix").should match(/spinnersuffix/)
  end
 
  it 'should provide link_to_remote with graceful degradition to html when javascript is off' do

     helper.link_to_remote_degrades("test",{:url=>{:controller=>"bob",:action=>"barker"}},{:href=>url_for(:action=>"barker", :controller=>"bob")}).should ==
      helper.link_to_remote("test",{:url=>{:controller=>"bob",:action=>"barker"}},{:href=>url_for(:action=>"barker", :controller=>"bob")})



     helper.link_to_remote_degrades("test",{:url=>{:controller=>"bob",:action=>"barker"}}).should ==
     helper.link_to_remote("test",{:url=>{:controller=>"bob",:action=>"barker"}},{:href=>url_for(:action=>"barker", :controller=>"bob")})
  end

  
  it 'should provide link_to_remote_if' do
    helper.link_to_remote_if(false,"blah").should == "blah"
    helper.link_to_remote_if(true,"links_to_remote", {:url=>{:action=>:index,:controller=>"main"}},{:style=>"display:none"}).should ==
      helper.link_to_remote_degrades("links_to_remote", {:url=>{:action=>:index,:controller=>"main"}},{:style=>"display:none"})
  end

  it 'should provide link_to_with_icon' do
    file="testing_of_Stuff.gif"
    url="http://www.test.com"
    r=helper.link_to_with_icon( file, url, " Suffix")
    r.should have_tag("a[href=?]>img[src*=?]",url, "icon_gif.gif")
    r.should match(/testing of Stuff Suffix/)

  end

  it 'should provide render_with_empty' do
    options={:collection=>[1,2,3],:empty=>"EMPTY RESULT"}
    helper.should_receive(:render).and_return("TREE")
    helper.render_with_empty(options).should == "TREE"
    options={:collection=>[],:empty=>"EMPTY RESULT"}
    helper.should_not_receive(:render)
    helper.render_with_empty(options).should == "EMPTY RESULT"
  end
end
