class MoveAllSchoolsAndAllStudentsToUsers < ActiveRecord::Migration
  def self.up
    User.joins(:special_user_groups).where(special_user_groups: {grouptype: 1}).update_all('all_schools = 1')
    User.joins(:special_user_groups).where(special_user_groups: {grouptype: 2}).update_all('all_students = 1')
    SpecialUserGroup.delete_all("grouptype in (1,2)")
  end

  def self.down
    User.find_all_by_all_schools(true).each{|u| u.special_user_groups.create!(district_id: u.district_id, grouptype: 1)}
    User.find_all_by_all_students(true).each{|u| u.special_user_groups.create!(district_id: u.district_id, grouptype: 2)}
  end
end
