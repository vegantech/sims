class System
  RESERVED_SUBDOMAINS = %w{ www asset demo asset2 asset1 asset0 mail staging }
  HASH_KEY = ''
  
  def self.news
    NewsItem.system
  end

  def self.roles
    Role::ROLES
  end

  def self.bootstrap
    if Country.count == 0
      Country.create!(:admin=>true,:name=>"System Administration", :abbrev=>:admin)
      Country.first.admin_district.users.first.update_attribute(:roles,'country_admin')
    end

  end

  def self.admin_district
    Country.admin.first.admin_district
  end

  def self.cache_key
     "system#{news.last(:order=>'updated_at').try(:cache_key)}"
  end


end
