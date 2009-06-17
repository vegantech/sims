module ImportCSV::FileHandling

  FILE_ORDER = ['schools.csv', 'students.csv', 'users.csv']
  def sorted_filenames filenames=@filenames
    filenames.sort_by do |f|
      FILE_ORDER.index(File.basename(f.downcase))  ||
      FILE_ORDER.length + 1
    end
  end

  def identify_and_unzip
    FileUtils.mkdir_p(@f_path)
    if @file.respond_to?(:original_filename)
      try_to_unzip(@file.path, @file.original_filename) or move_to_import_directory
    else  #passed in a string
      try_to_unzip(@file, @file) or @filenames =[@file]
    end
  end

  def move_to_import_directory
    base_filename = File.basename(@file.original_filename)
    new_filename= File.join(@f_path,base_filename)
    FileUtils.mv @file.path,new_filename
    @filenames = [new_filename]
  end

  #string nonzip 
  #string zip
  #file nonzip
  #file zip


  def try_to_unzip filename, originalname
    if originalname =~ /\.zip$/ 
      @messages << "Problem with zipfile #{originalname}" unless
        system "unzip  -qq -o #{filename} -d #{@f_path}"
      @filenames = Dir.glob(File.join(@f_path, "*.csv")).collect
    else
      false
    end

  end
end
