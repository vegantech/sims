#!/usr/bin/ruby

require 'fileutils'

def base_path
  "district_uploads/"
end

def local_dirs path
  Dir.entries(path).select do |entry|
    File.directory?("#{path}#{entry}") && !(['.', '..'].include?(entry))
  end
end

def local_files path
  Dir.entries(path).select do |entry|
    File.file?("#{path}#{entry}") &&
    entry[0] != '.' &&
    (Time.new - File.mtime("#{path}#{entry}")) > 30
  end
end

def district_dirs
  local_dirs(base_path).reject {|entry| entry == "import"}
end

def get_mv_source path, file
  "#{path}#{file}"
end

def get_mv_target district, file
  "#{base_path}import/#{district}/#{file}"
end

def move_files_and_process path, district
  local_files(path).each do |file|
    system "mkdir #{base_path}import/#{district}"
    mv_target = get_mv_target district, file
    FileUtils.mv(get_mv_source(path, file), mv_target)
    system "bundle exec rails runner -e test"\
           " \"ImportCSVFromRunner.new '#{mv_target}', #{district}\""
  end
  local_dirs(path).each do |dir|
    move_files_and_process "#{path}#{dir}/", district
  end
end

district_dirs.each do |district|
  move_files_and_process "#{base_path}#{district}/", district
end