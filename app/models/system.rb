class System
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


  end

end
