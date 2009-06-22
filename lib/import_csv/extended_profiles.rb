class ExtendedProfile
  CSV_HEADERS = [:id_district, :arbitrary]
end

module ImportCSV::ExtendedProfiles
  def load_arbitrary_extended_profile_content_from_csv file_name
    @students = ids_by_id_district Student

    # @role=Role.find_by_name(role) or return false
    # @existing_users = @role.users.all(:conditions => ["district_id = ? and id_district is not null", @district.id],:select => "id, id_district")
    
    if load_extended_profiles_from_csv file_name
      # @desired_users = district.users(true).all(:select => "id, id_district", 
      # :conditions => ["district_id = ? and id_district is not null and id_district in (?) ", @district.id,
      # @ids.compact]
      # )

      # # insert desired - existing
      # @role.users << (@desired_users  -@existing_users)
      # @extended_profile

      # # remove existing - desired
      # @role.users.delete(@existing_users - @desired_users)
    end
  end

  def load_extended_profiles_from_csv file_name
    lines = FasterCSV.read(file_name, ImportCSV::DEFAULT_CSV_OPTS)
    lines.each do |line|
      # some CSV such as sql server appends a blank line and a rowcount
      next  if line[0] =~  /^-+|\(\d+ rows affected\)$/

      process_extended_profile_line line
    end

    @messages << "Successful import of #{File.basename(file_name)}"
  end

  def process_extended_profile_line line
    puts "Now processing line with #{line[:id_district]} and #{line[:arbitrary]}"
    id_district = line[:id_district].to_i
    #    puts Student.find_by_id_district.inspect
    student_id = @students[id_district] #|| 'add_some_students_to_your_scenario'
    puts "You should create a file somewhere #{@district.id}/#{student_id}"
    path = "tmp/qqq/#{@district.id}/extended_profiles/"
    FileUtils.mkdir_p(path)
    File.open("#{path}/#{student_id}", 'w+') {|f| f << 'fubar'}
  end
end
