class AdministrationCell < Cell::Base
  helper ApplicationHelper
  def system opts
    @show=opts[:district].system_admin?
    render
  end

  def district opts
    @current_district = opts[:district]
    @show_schools = opts[:user].authorized_for?('district/schools',:write_access)
    @show_users = opts[:user].authorized_for?('district/users', :write_access)
    @show_students =opts[:user].authorized_for?('district/students',:write_access)
    @show_district= opts[:user].authorized_for?('districts',:write_access)
    @show_flag_descriptions= opts[:user].authorized_for?('flag_descriptions',:write_access)

    @show = @show_schools || @show_users || @show_students || @show_district || @show_flag_descriptions
    render

  end

  def school opts
    @school = opts[:school]
    @user = opts[:user]
    @show = @user.user_school_assignments.admin.find_by_school_id(@school)
    render
  end
end
