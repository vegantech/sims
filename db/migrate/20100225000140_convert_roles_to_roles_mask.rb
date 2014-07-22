class ConvertRolesToRolesMask < ActiveRecord::Migration
  def self.up
    User.all.each do |u|
      u.roles = u.old_roles.collect(&:name)
      u.update_attribute(:roles_mask,u.roles_mask)
    end
  end

  def self.down
    db_roles = Role.all.group_by(&:name)
    User.all.each do |u|
      u.old_roles=db_roles.collect{|k,v| v if  u.roles.include?(k)}.compact.flatten
    end
  end
end

class User < ActiveRecord::Base
  ROLES = ["district_admin", "content_admin", "school_admin", "regular_user", "news_admin", "state_admin", "country_admin"]
  has_and_belongs_to_many :old_roles, join_table: 'roles_users', class_name: 'Role'

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
end

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  set_table_name 'roles'
end

