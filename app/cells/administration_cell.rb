class AdministrationCell < Cell::Base
  def system
    @show=@opts[:district].system_admin? 
  end

  def country
    @district=@opts[:district]
    @show=@district.country_admin?
  end

  def state
    @district=@opts[:district]
    @show=@district.admin?
  end

  def district
    @district = @opts[:district]
    @show_schools = @opts[:user].authorized_for?('district/schools',:write)
    @show_users = @opts[:user].authorized_for?('district/users', :write)
    @show_students =@opts[:user].authorized_for?('district/students',:write)
    @show_district= @opts[:user].authorized_for?('districts',:write)
    
    @show = @show_schools || @show_users || @show_students || @show_district

  end

  def school
    @school = @opts[:school]
    @user = @opts[:user]
    @show = @user.user_school_assignments.admin.find_by_school_id(@school)
  end
end
