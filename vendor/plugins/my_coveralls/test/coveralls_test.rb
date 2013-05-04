require 'test/unit'
ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + File.join("..","..","..","..")
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

class CoverallsTest < Test::Unit::TestCase
  def test_default_require_all
   all_files = Coveralls.require_all_ruby_files
   controllers = (Dir.glob(File.join(ENV['RAILS_ROOT'],"app","controllers","**","*.rb")))
   libs = (Dir.glob(File.join(ENV['RAILS_ROOT'],"lib","*.rb")))

   assert_equal libs,all_files.flatten & libs
   assert_equal controllers,all_files.flatten & controllers
  end

  def test_invalid_require
    all_files = Coveralls.require_all_ruby_files "dog_not_here_zzz"
    assert_equal [],all_files.flatten
  end

  def test_specify_directory
   all_files = Coveralls.require_all_ruby_files File.join("app","controllers")
   controllers = (Dir.glob(File.join(RAILS_ROOT,"app","controllers","**","*.rb")))

   assert_equal controllers, all_files.flatten
  end

end
