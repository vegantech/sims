#support for the old Factory(:x) as an alias for Factory.create

unless defined? Factory
  def Factory(*args)
    FactoryGirl.create(*args) if defined? FactoryGirl
  end
end
