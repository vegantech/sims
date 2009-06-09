module ImportCSV
  require 'fastercsv'
  

  USER_HEADERS=['id_district','username',"first_name", "last_name", "middle_name", "suffix", "email","passwordhash","salt"]


  def self.load_from_csv file_name, district, model_name
    constant_name = "#{model_name.upcase}_HEADERS"
    puts "invalid object" and return false unless ImportCSV.const_defined?(constant_name)
    
    constant = "ImportCSV::#{constant_name}".constantize

     if File.exist?(file_name)
      lines = FasterCSV.read(file_name)
      
      header_line = lines.first.collect(&:strip)
     
      if starts_with?(constant,header_line)
        if lines[1].first.include?("----")
          offset = 2
        else
          offset = 1
        end

        lines[offset..-1].each do |line|
          break if line.length < constant.length  #some CSV such as sql server appends a blank line and a rowcount

          self.send("process_#{model_name}_line", district, line)
        end
      else
        puts "invalid header #{header_line.inspect}"
        return false
      end
    else
      puts("#{file_name} did not exist when attempting to load users from csv")
      return false
    end
    true
   

  end
  
  def self.load_users_from_csv file_name, district
    load_from_csv file_name, district, "user"
  end

  def self.process_user_line district, line
    username = line[1].strip
    found_user = district.users.find_by_username(username) || district.users.build(:username => username)
    USER_HEADERS.each_with_index do |field,idx|
      found_user[field] =
      case field
        when 'passwordhash'
          line[idx].strip.to_i(16).to_s(16)
        when 'id_district'
          line[idx].strip.to_i
        else
          line[idx].strip
      end
    end
    found_user.save(validate=false)
  end

  def self.starts_with?(should_start_with, candidate)
    candidate[0..(should_start_with.length-1)] == should_start_with
  end
end
