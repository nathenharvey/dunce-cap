before "deploy:web:disable", "notification:web:disable"
after "deploy:web:enable", "notification:web:enable"
before "deploy", "notification:deploy:start"
after "deploy", "notification:deploy:complete"

namespace :notification do
  
  namespace :web do
    task :disable do
      notify("The #{application} #{rails_env} website is about to be disabled")
    end
  
    task :enable do
      notify("The #{application} #{rails_env} website has been enabled")
    end
  end

  namespace :deploy do
    task :start do
      notify("The #{application} #{rails_env} website deploy has begun")  
    end
  
    task :complete do
      notify("The #{application} #{rails_env} website deploy completed successfully")  
    end
  end
end

def notify(message)
  logger.info(Time.now.to_s + ": " + message)
  if installed?("growlnotify")
    `growlnotify -m "#{message}"`
  end
  # and we could do something cool here like post to basecamp,send a tweet, etc.
end


def installed?(app)
  !`which #{app}`.empty?
end