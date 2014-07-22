require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::AdminsOfSchools do
  it_should_behave_like "csv importer"

  describe 'import' do
    subject {CSVImporter::AdminsOfSchools.new(Rails.root.join("spec","csv","admins_of_schools.csv").to_s, upload_district)}
    let!(:upload_district) {Factory(:district)}
    let!(:other_district) {Factory(:district)}
    let!(:user_to_add) {Factory(:user, :district => upload_district, :district_user_id => 'user_to_add')}
    let!(:user_to_remove) {  Factory(:user, :district => upload_district, :district_user_id => 'user_to_remove',
                                            :user_school_assignments => [UserSchoolAssignment.new(:admin => true, :school => school)])}
    let!(:school) {Factory(:school, :district => upload_district, :district_school_id => 222)}
    let!(:other_school) {Factory(:school, :district => other_district, :district_school_id => 222)}
    let!(:other_district_user_to_add) {Factory(:user, :district => other_district, :district_user_id => 'user_to_add')}
    let!(:other_district_user_to_remove) {  Factory(:user, :district => other_district, :district_user_id => 'user_to_remove',
                                                           :user_school_assignments => [UserSchoolAssignment.new(:admin => true, :school => other_school)])}
    let!(:school_without_key) {Factory(:school, :district => other_district)}
    let!(:user_without_key_to_remove) {  Factory(:user, :district => upload_district,
                                                        :user_school_assignments => [UserSchoolAssignment.new(:admin => true, :school => school)])}
    let!(:user_to_non_admin) {  Factory(:user, :district => upload_district, :district_user_id => 'user_with_non_admin',
                                               :user_school_assignments => [UserSchoolAssignment.new(:admin => false, :school => school)])}
    let!(:user_with_key_but_assignment_to_school_without_key) { Factory(:user, :district => upload_district, :district_user_id => 'user_with_other_key',
                                                                               :user_school_assignments => [UserSchoolAssignment.new(:admin => true, :school => school_without_key)])}
    let(:import_messages) { subject.import }

    it 'should import_properly' do
      #I would have liked to split this up into multiple it blocks, but the lets would run each time
      #I should rewrite it with before(:all) and instance variables
      import_messages
      user_to_add.user_school_assignments.admin.collect(&:school_id).should == [school.id]
      user_to_remove.user_school_assignments.admin.should be_blank
      other_district_user_to_add.user_school_assignments.admin.should be_blank
      other_district_user_to_remove.user_school_assignments.admin.should_not be_blank
      user_without_key_to_remove.user_school_assignments.admin.should_not be_blank
      user_to_non_admin.user_school_assignments.should_not be_blank
      user_with_key_but_assignment_to_school_without_key.user_school_assignments.should_not be_blank
    end
  end
end

