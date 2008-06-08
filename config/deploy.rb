def get_next_release
  list = `svn list #{svnfulladdress}/branches | grep RB-`
  list_numbers = []
  list.each do |item|
    item =~ /RB-([0-9].*)\//
    list_numbers << $1.to_i
  end
  next_release = list_numbers.sort.last.to_i + 1
  system "svn copy -m \"Creating release branch\" #{svnfulladdress}/trunk #{svnfulladdress}/branches/RB-#{next_release}"
  system "svn copy -m \"Creating tag release\" #{svnfulladdress}/branches/RB-#{next_release} #{svnfulladdress}/tags/REL-#{next_release}"
  next_release 
end


set :user, "podcasry"
set :runner, user
set :application, "podcast"
default_run_options[:pty] = true
set :deploy_to, "/home/#{user}/railsapp/#{application}"
set :svnfulladdress, "https://secure.svnrepository.com/s_tapajos/podcast"
set :deploy_via, :export
set :repository,  "#{svnfulladdress}/tags/REL-#{get_next_release} --username \"site_podcast\" --password \"wniv634py983.sd\""

namespace :deploy do
  task :restart, :roles => :app do
    send(:run, "cd #{deploy_to}/#{current_dir} && mongrel_rails stop && sleep 1s && rm -f log/mongrel.pid && mongrel_rails start -e production -p 12003 -d")
  end
end

task :after_update_code, :roles => :app do
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