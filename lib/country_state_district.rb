module CountryStateDistrict
  def dropdowns
    @districts=nil
    subdomains
    return if current_user_id


    districts=@districts || District.normal

    districts=District.admin if districts.blank?
    @current_district ||= districts.first if districts.size ==1
    if params[:district] and params[:district][:id]
      @current_district ||= District.find(params[:district][:id])
    end
    

    unless districts.size == 1
      @districts ||= districts
    end
    @current_district ||= District.new(:name => 'Please Select a District')

  end
end
