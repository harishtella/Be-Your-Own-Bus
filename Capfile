load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'config/deploy'

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
   
  task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  after :symlink do
    run "rm -f ~/public_html;ln -s #{deploy_to}/current/public ~/public_html"
    run "cp ~/environoment.rb #{deploy_to}/current/config/environoment.rb"
  end
end

