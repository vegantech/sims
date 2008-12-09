class AdministrationCell < Cell::Base
  def system
    @show=@opts[:district].system_admin?
  end

  def country
    nil
  end
  def state
    nil
  end
  def district
    nil
  end
end
