set :application, 'designax'
set :repo_url, 'https://github.com/xengineer/designax.git'
set :deploy_to, "/opt/app/designax/"

set :use_sudo, true
set :scm, :git
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"]

set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".gitignore"]

before "deploy", "deploy:echo"
namespace :deploy do
  task :echo do
    on roles(:app) do
      execute "echo /etc/init.d/unicorn stop"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "mkdir -p #{deploy_to}/current/tmp/pids"
    end
  end
end
