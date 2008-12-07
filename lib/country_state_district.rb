module CountryStateDistrict
  def dropdowns
  countries=Country.normal
    unless countries.size ==1
      @countries=countries
    end
    @country ||= countries.first
    states=@country.states.normal

    unless states.size == 1
      @states=states
    end
    @state ||=states.last  #TODO This selects WI by default, since it is currently last
    

    districts=@state.districts.normal
    if params[:district]
      @district ||= District.find(params[:district][:id])
    end

    unless districts.size == 1
      @districts = districts
    end

    @district ||= districts.first
    session[:district_id]=@district.id if @district

  end
end
