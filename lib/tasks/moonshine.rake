namespace :moonshine do
  namespace :app do
    desc "Tasks run when Moonshine bootstraps the deployed application"
    task :bootstrap do
      Rake::Task['db:fixtures:load'].invoke
    end
  end
  namespace :update do
    desc "Do not update moonshine unless you are using bundler or they did my pull"
    task :default2  do
      puts "Make sure they pulled in your fix, or you're using bundler before running this,  and delete this from lib/tasks/moonshine.rak"
    end

  end
end
