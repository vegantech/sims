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
    @show = true

  end

  def school
    @school = @opts[:school]
    @user = @opts[:user]
    @show = @user.user_school_assignments.admin.find_by_school_id(@school)
  end
end
