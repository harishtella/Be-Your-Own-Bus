load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'config/deploy'

namespace :deploy do
  task :start, :roles => :app do
    run "rm -rf /home/#{user}/public_html;ln -s #{current_path}/public /home/#{user}/public_html"
    run "cd ~/script && ./restart_mongrel.sh"
    #run "touch #{deploy_to}/current/tmp/restart.txt"
  end
   
  task :restart, :roles => :app do
    run "cd ~/script && ./restart_mongrel.sh"
    #run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  after "deploy:symlink" do
    #run "rm -f ~/public_html;ln -s #{deploy_to}/current/public ~/public_html"
    # dont need this anymore because restart_mongrel.sh calls mongrel in
    # production mode 
    #run "cp ~/byob_deploy_files/environment.rb #{deploy_to}/current/config/environment.rb"
  end
end

after "deploy:stop", "delayed_job:stop"
after "deploy:start", "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

namespace :delayed_job do

  def rails_env
    fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env)}" : ''
  end
  
  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path};#{rails_env} script/delayed_job stop"
  end

  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path};#{rails_env} script/delayed_job start"
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path};#{rails_env} script/delayed_job restart"
  end
end

