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
    nil
  end
end
