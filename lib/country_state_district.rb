module CountryStateDistrict
  def dropdowns
    subdomains
    return if current_user_id
    countries=@countries ||Country.normal

    countries= Country.admin if countries.blank? 

    unless countries.size ==1
      @countries=countries
    end
    @country ||= countries.first


    states=@states || @country.states.normal
    states = @country.states.admin if states.blank?

    unless states.size == 1
      @states=states
    end
    @state ||=states.last  #TODO This selects WI by default, since it is currently last
    

    districts=@districts || @state.districts.normal

    districts=@state.districts.admin if districts.blank?
    if params[:district]
      @current_district = District.find(params[:district][:id])
    end

    unless districts.size == 1
      @districts ||= districts
    end
    @current_district ||= districts.first

  end
end
