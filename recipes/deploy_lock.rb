before "deploy", "deploy:check_lock"
before "deploy", "deploy:semaphor"
after "deploy", "deploy:unlock"

namespace :deploy do
  def deploy_lockfile
   "#{shared_path}/system/capistrano.lock"
  end

  task :semaphor do
    set :lock_message, "Locked for depoyment by #{user}"
    lock  
  end
  
  desc "asks you for a message and locks the deploy. People attempting the deploy will fail and see your lock message"
  task :lock do
    if "#{lock_message}".empty?
      set :lock_message, Capistrano::CLI.ui.ask("Lock Message: ")
    end
    put lock_message, deploy_lockfile, :mode => 0777
  end

  desc "unlocks the deploy once it is locked.  Depending on how your server is set up, people other than the locker might not have file permissions"
  task :unlock do
    run "rm #{deploy_lockfile}"
  end

  desc "lets you know if the deploy is locked"
  task :check_lock do
    lock_contents = ""
    run "if [ -e #{deploy_lockfile} ]; then cat #{deploy_lockfile}; fi" do |ch, stream, out|
      lock_contents = out
    end
    if !lock_contents.empty?
      notify lock_contents unless lock_contents.empty?
      raise lock_contents
    end
  end
end