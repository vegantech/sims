class MyCoveralls
  # Method to require all ruby classes when calculating code coverage.
  # Call this to not leave untested files out of the code coverage percentages.
  def self.require_all_ruby_files(target_dirs=["lib", "app"])
    Array(target_dirs).collect do |target_dir|
      dir = Rails.root.join(target_dir, "**","*.rb")
      Dir.glob(dir).each do |ruby_file|
        obj = ruby_file.split("#{target_dir}/",2).last.split(".rb").first
        obj = obj.split("/",2).last if target_dir == "/app"
        begin
          obj.classify.constantize
        rescue NameError, LoadError
          #app/manifests are used with moonshine, but not needed during project execution
           require ruby_file
        end
      end
    end

  end

end
