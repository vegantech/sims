class System
  RESERVED_SUBDOMAINS = %w{ www asset demo asset2 asset1 asset0 mail staging assets }
  HASH_KEY = ''

  def self.news
    NewsItem.system
  end

  def self.roles
    Role::ROLES
  end

  def self.bootstrap
    if admin_district.nil?
      d=District.create(:admin => true, :name => "Administration", :abbrev => 'admin')
      d.send(:create_admin_user)
      u=d.users.first
      u.roles=['local_system_administrator','state_admin']
      u.save!
    end

  end

  def self.admin_district
    District.admin.first
  end

  def self.cache_key
     "system#{news.last(:order=>'updated_at').try(:cache_key)}"
  end


end
