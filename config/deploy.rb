set :application, "quizzy"
set :repository,  "ssh://gitolite@aurora.sology.eu/quizzy"

server "aurora.sology.eu", :app, :web, :db, :primary => true

set :deploy_to, "/srv/quizzy"
set :deploy_via, :remote_cache
set :default_shell, "bash -l"

set :user, 'webapps'
set :use_sudo, false

namespace :deploy do
	task :start do ; end
	task :stop do ; end
	task :restart, :roles => :app, :except => { :no_release => true } do
		run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
	end
end
