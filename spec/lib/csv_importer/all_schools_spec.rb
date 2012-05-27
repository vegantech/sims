require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')


describe CSVImporter::AllSchools do
  it_should_behave_like "csv importer"

  describe 'import' do
    subject {CSVImporter::AllSchools.new(Rails.root.join("spec","csv","roles_base.csv").to_s, upload_district)}
    let!(:upload_district) {Factory(:district)}
    let!(:other_district) {Factory(:district)}
    let!(:user_to_add) {Factory(:user, :district => upload_district, :district_user_id => 'should_gain_role')}
    let!(:user_to_remove) {  Factory(:user, :district => upload_district, :district_user_id => 'user_to_remove',:all_schools => true)}
    let!(:user_to_keep) {  Factory(:user, :district => upload_district, :district_user_id => 'should_keep_role',:all_schools => true)}
    let!(:other_district_user_to_add) {Factory(:user, :district => other_district, :district_user_id => 'should_gain_role')}
    let!(:other_district_user_to_remove) {  Factory(:user, :district => other_district, :district_user_id => 'user_to_remove', :all_schools => true)}
    let!(:user_without_key_to_remove) {  Factory(:user, :district => upload_district, :all_schools => true)}
    let(:import_messages) { subject.import }



    it 'should import_properly' do
      #I would have liked to split this up into multiple it blocks, but the lets would run each time
      #I should rewrite it with before(:all) and instance variables
      puts import_messages
      user_to_add.reload.all_schools.should be
      user_to_remove.reload.all_schools.should_not be
      other_district_user_to_add.reload.all_schools.should_not be
      other_district_user_to_remove.reload.all_schools.should be
      user_without_key_to_remove.reload.all_schools.should be
      user_to_keep.reload.all_schools.should be
    end
  end
end
