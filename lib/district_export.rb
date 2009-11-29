require 'fileutils'
require 'fastercsv'
class DistrictExport
  def self.generate(district)
    dir = "#{RAILS_ROOT}/tmp/district_export/#{district.id}/"
    
    FileUtils.mkdir_p dir unless File.exists? dir
    FileUtils.rm(Dir.glob(dir +"*"))

    self.generate_csv(dir,district,'students', 'id,district_student_id')
    self.generate_csv(dir,district,'users', 'id,district_user_id')
    self.generate_csv(dir,district,'schools', 'id,district_school_id')

    
    #zip files
  end



  def self.generate_csv(dir,district, table, headers, conditions="where district_id = #{district.id}")
     FasterCSV.open("#{dir}#{table}.csv", "w") do |csv|
      csv << headers.split(',')
      Student.connection.select_rows("select #{headers} from #{table} #{conditions}").each do |row|
        csv << row
      end
    end
    
  end
end
