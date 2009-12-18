set :application, "byob"
set :user, "harisht"
set :domain, "harishtella.info"
set :ssh_options, {:forward_agent => true} 

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:

# If you aren't using Subversion to manage your source code, specify
# your SCM below:

set :repository,  "#{user}@#{domain}:/home/harisht/git/byob.git"
set :scm, "git"
set :branch, "new_layout_beta"

set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :checkout
set :group_writable, false 

default_run_options[:pty] = true

role :app, domain 
role :web, domain
role :db,  domain, :primary => true
