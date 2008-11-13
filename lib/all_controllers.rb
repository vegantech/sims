class AllControllers
  def self.names
    Dir.chdir(File.dirname(__FILE__)+'/../app/controllers') do
      Dir['**/*_controller.rb'].sort.map{|f| f.sub(/_controller.rb$/, '')}
    end
  end

  NAMES = self.names
end