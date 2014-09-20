class ImportCSVFromRunner
  def initialize path, district_id
    if (district = District.find(district_id))
      File.open(path, 'r') do |file|
        DistrictUploadJob.new.async_perform file, district
      end
    end
  end
end