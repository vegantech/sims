require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DistrictExport do
  describe 'generate class method' do
    describe 'passed a valid district' do
      it 'should fail' do
        pending 'need to implement'
        fail
      end
      it 'should include users that have left the district' do
        d = FactoryGirl.create :district
        in_district = FactoryGirl.create :user, district: d
        removed_from_this_district = FactoryGirl.create :user, district: d
        other_removed = FactoryGirl.create :user
        removed_from_this_district.remove_from_district
        other_removed.remove_from_district
        DistrictExport.generate(d)
        File.read(Rails.root.join("tmp","district_export",d.id.to_s,"users.csv")).should ==
          "id,district_user_id\r\n#{in_district.id},\"\"\r\n#{removed_from_this_district.id},\"\"\r\n"
      end
    end
  end
end
