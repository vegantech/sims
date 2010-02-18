namespace :moonshine do
  namespace :app do
    desc "Tasks run when Moonshine bootstraps the deployed application"
    task :bootstrap do
      Rake::Task['db:fixtures:load'].invoke
    end
  end
end
