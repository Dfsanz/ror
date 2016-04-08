# Capistrano deployment script on Site 5
# By: Diego Sanz
# Tested with capistrano 1.2 12/12/2007

# =============================================================================
# Customize these variables
# =============================================================================

set :application, "bmc"
set :user, "rubynewb"
set :password, "steelpixel"
set :keep_releases, 2 # Less releases, less space wasted
set :domain, "brickellmiamicondos.com"

# =============================================================================
# Do not change these variables
# =============================================================================

set :use_sudo, false # Necessary to run on Site5
set :group_writable, false
set :repository, "svn+ssh://#{user}@#{domain}/home/#{user}/svn_repo/#{application}/trunk"
set :deploy_to, "/home/#{user}/apps/#{application}" # defaults to "/u/apps/#{application}"

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# =============================================================================
# SSH OPTIONS
# =============================================================================

ssh_options[:keys] = %w(/home/rubynewb/.ssh/authorized_keys)

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)
desc "Restart the FCGI instances"
task :restart, :roles => :app do 
  set :use_sudo, false
  send(run_method, "skill -u #{user} -c ruby")
end

desc "Fix permissions" 
task :after_update_code do
  run "find #{release_path}/public -type d -exec chmod 0755 {} \\;"
  run "find #{release_path}/public -type f -exec chmod 0644 {} \\;"
  run "chmod 0755 #{release_path}/public/dispatch.*"
end
# desc "Restart the FCGI instances"
# task :restart, :roles => :app do 
#   set :use_sudo, false
#   send(run_method, "skill -u #{user} -c ruby")
# end
# 
# desc "Fix permissions" 
# task :after_update_code do
#   run "find #{release_path}/public -type d -exec chmod 0755 {} \\;"
#   run "find #{release_path}/public -type f -exec chmod 0644 {} \\;"
#   run "chmod 0755 #{release_path}/public/dispatch.*"
#   # run "chmod 755 #{current_path}/public/dispatch.fcgi" 
#   # run "touch #{current_path}/public/dispatch.fcgi" 
# end
