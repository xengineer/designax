set :application, 'designax'
set :repo_url, 'https://github.com/xengineer/designax.git'
set :deploy_to, "/opt/app/designax/"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :use_sudo, true
# set :deploy_to, '/var/www/my_app'
set :scm, :git
#set :repository, 'https://github.com/xengineer/designax.git'
#set :branch, 'master'
set :branch, fetch(:branch, 'master')

set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".gitignore"]

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

#task :list do
#  on roles(:web) do
#    execute "ls"
#  end
#end

before "deploy", "deploy:echo"
namespace :deploy do
  task :echo do
    on roles(:app) do
      #try_sudo "chown -R root:nubee #{fetch(:deploy_to)}"
      execute "echo /etc/init.d/unicorn stop"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "mkdir -p #{deploy_to}/current/tmp/pids"
      #execute "/etc/init.d/unicorn start"
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end
end
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      # Here we can do anything such as:
#      # within release_path do
#      #   execute :rake, 'cache:clear'
#      # end
#    end
#  end


#  after :finishing, 'deploy:cleanup'

#end
