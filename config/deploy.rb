# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'bookclubfiction'
set :repo_url, 'git@github.com:kelsin/bookclubfiction.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/travis/bookclubfiction'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :ssh_options, keys: ["config/deploy_id_rsa"], forward_agent: true if File.exist?("config/deploy_id_rsa")

set :rbenv_ruby, '2.1.3'

set :default_env, {
  'DEVISE_SECRET' => 'devise_secret'
}
