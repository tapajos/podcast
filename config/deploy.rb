set :user, "podcasry"
set :runner, user
set :application, "podcast"
default_run_options[:pty] = true
set :repository,  "git://github.com/tapajos/podcast.git"
set :scm, "git"
set :deploy_to, "/home/#{user}/railsapp/#{application}"

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

task :after_update_code, :roles => :app do
  run "cp #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
  run "cd #{release_path} && rake db:migrate RAILS_ENV=production"
  run "chmod 755 #{release_path}/public -R"
  run "rm -Rf #{release_path}/public/podcasts"
  run "ln -s /home/#{user}/download.podcast.rubyonrails.pro.br #{release_path}/public/podcasts"
  
  count = (self[:keep_releases] || 10).to_i
  if count >= releases.length
    logger.important "no old releases to clean up"
  else
    logger.info "keeping #{count} of #{releases.length} deployed releases"
    directories = (releases - releases.last(count)).map { |release|
      File.join(releases_path, release) }.join(" ")
    send(:run, "rm -rf #{directories}")
  end
  
end

role :app, "podcast.rubyonrails.pro.br"
role :web, "podcast.rubyonrails.pro.br"
role :db,  "podcast.rubyonrails.pro.br", :primary => true