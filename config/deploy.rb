# config valid only for current version of Capistrano
lock '3.16.0'

#FIXME add your app name here
set :application, 'aws_app'
#FIXME replace 'git@github.com:YOUR-GIT-REPO-HERE' with your git clone url
set :repo_url, 'https://github.com/DominiqueElisabeth/aws_app'
#FIXME add location on the server here
set :deploy_to, '/var/www/aws_app'
set :branch, ENV['BRANCH'] || 'main'

set :linked_files, %w{.env config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}

set :keep_releases, 5
# Ruby
set :rbenv_ruby, '2.6.5'
set :rbenv_type, :system

set :log_level, :info
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end
  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
