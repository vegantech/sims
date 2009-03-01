class System
  RESERVED_SUBDOMAINS = %w{ www asset demo asset2 asset1 asset0 mail staging }
  def self.news
    NewsItem.system
  end

  def self.roles
    Role.system
  end

  def self.bootstrap
    if Country.count == 0
      Country.create!(:admin=>true,:name=>"System Administration", :abbrev=>:admin)

    end

    if Role.count == 0
      r=Role.create!(:name=>"country_admin")
      r.rights.create!(:controller=>"countries", :read_access=>true, :write_access=>true)
      Country.first.admin_district.users.first.roles << r

    end


  end

end
