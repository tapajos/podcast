set :user, "podcasry"
set :runner, user
set :application, "podcast"
default_run_options[:pty] = true
set :repository,  "git@github.com:vanpelt/rails-app.git"
set :scm, "git"
# set :scm_passphrase, "p00p" #This is your custom users password
set :deploy_to, "/home/#{user}/railsapp/#{application}"
set :ssh_options, { :forward_agent => true }

namespace :deploy do
  task :restart, :roles => :app do
#    sudo "#{lsws_cmd} restart"
  end
end

task :after_update_code, :roles => :app do
  run "cd #{release_path} && rake db:migrate RAILS_ENV=production"
  run "chmod 755 #{release_path}/public -R"
  run "rm -Rf #{release_path}/public/podcasts"
  run "ln -s #{deploy_to}/shared/podcasts #{release_path}/public/podcasts"
  
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
