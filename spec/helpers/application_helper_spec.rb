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

  it 'should provide link_to_with_icon' do
    file="testing_of_Stuff.doc"
    url="http://www.test.com"
    r=helper.link_to_with_icon( file, url, " Suffix")
    r.should have_tag("a[href=\"#{url}\"]>img[src*=\"icon_doc.gif\"]")
    r.should match(/testing of Stuff Suffix/)
    r=helper.link_to_with_icon( "no.ztb", url, " Suffix").should have_tag("a[href=\"#{url}\"]>img[src*=\"icon_htm.gif\"]")

  end

  it 'should provide render_with_empty' do
    options={collection: [1,2,3],empty: "EMPTY RESULT"}
    helper.should_receive(:render).and_return("TREE")
    helper.render_with_empty(options).should == "TREE"
    options={collection: [],empty: "EMPTY RESULT"}
    helper.should_not_receive(:render)
    helper.render_with_empty(options).should == "EMPTY RESULT"
  end

  describe 'li_link_to_if_authorized' do
    it 'should be empty if not authorized' do
      helper.should_receive(:link_to_if_authorized).and_return nil
      helper.li_link_to_if_authorized('Shawn').should be_nil
    end
    it 'should wrap the link in li tags if authorized' do

      helper.should_receive(:link_to_if_authorized).and_return 'zzz'
      helper.li_link_to_if_authorized('Shawn').should == '<li>zzz</li>'
    end
  end

  describe 'link_to_if_authorized' do
    it 'should go to a url if authorized' do
      helper.should_receive(:current_user).and_return(mock_user('authorized_for?'=>true))
      helper.link_to_if_authorized('rauknauk','/railmail').should == helper.link_to('rauknauk','/railmail')
    end

    it 'should be nil if not authorized' do
      helper.should_receive(:current_user).and_return(mock_user('authorized_for?'=>false))
      helper.link_to_if_authorized('rauknauk','/railmail').should be_nil

    end

    it 'should link to a hash based path' do
      helper.should_receive(:current_user).and_return(mock_user('authorized_for?'=>true))
      helper.link_to_if_authorized('rauknauk',controller: 'railmail').should ==  helper.link_to('rauknauk','/railmail')

    end

    it 'should prepend a / to the controller to fix 236' do
      helper.should_receive(:current_user).and_return(mock_user('authorized_for?'=>true))
      helper.should_receive(:link_to).with("rauknauk", {controller: "/railmail"}, {}).and_return('eeeeeeee')
      helper.link_to_if_authorized('rauknauk',controller: 'railmail').should ==  'eeeeeeee'

    end

  end

  describe 'body' do
    it 'without user or student' do
      helper.stub!(current_user: nil)
      helper.stub!(current_student_id: nil)
      helper.body(){"dog"}.should == "<body>dog</body>"
    end
    it 'without student' do
      helper.stub!(current_user: mock_user(id: 6))
      helper.stub!(current_student_id: nil)
      helper.body(){"dog"}.should == '<body data-user="6">dog</body>'
    end

    it 'with user and student' do
      helper.stub!(current_user: mock_user(id: 6))
      helper.stub!(current_student_id: 82)
      helper.body(){"dog"}.should == '<body data-student="82" data-user="6">dog</body>'
    end

  end

  describe 'restrict_to_principals?' do
    it 'should return false when the user is a principal of the student'  do
      user = mock_user
      student=mock_student(principals: [user])
      helper.should_receive(:current_district).and_return(mock_district('restrict_free_lunch?'=>true))
      helper.should_receive(:current_user).and_return(user)

      helper.restrict_to_principals?(student).should be_false

    end

    it 'should return false when the district has the flag off'  do
      helper.should_receive(:current_district).and_return(mock_district('restrict_free_lunch?'=>false))
      student=mock_student()
      helper.restrict_to_principals?(student).should be_false
    end

    it 'should return true when the district has the flag on and the user is not a principal'  do
      user = mock_user
      student=mock_student(principals: [])
      helper.should_receive(:current_user).and_return(user)
      helper.should_receive(:current_district).and_return(mock_district('restrict_free_lunch?'=>true))
      helper.restrict_to_principals?(student).should be_true
    end
  end

  describe 'help_popup' do
    it 'should escape properly' do
      helper.help_popup(%q{test<script>alert('HACKED')</script><p> 'quoted' "double_quoted" </p>}).should == helper.content_tag(:span,"?", :class => "help-question", :'data-help' => "test<p> 'quoted' &quotdouble_quoted&quot </p>".html_safe)
    end

  end

end
