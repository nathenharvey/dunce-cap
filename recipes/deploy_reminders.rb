after "deploy", "reminders:show"

namespace :reminders do
  def reminder_file
   "#{shared_path}/system/reminders.txt"
  end
  
  desc "adds a reminder that will be shown on deploy in the console of the next deployer"
  task :add do  
    set :reminder, Capistrano::CLI.ui.ask("Reminder: ")
    run "echo \"user: #{user}\" >> #{reminder_file}"
    run "echo \"On: #{Time.new.to_s}\" >> #{reminder_file}"
    run "echo \"Message: #{reminder}\" >> #{reminder_file}"
    run "echo \"\n\" >> #{reminder_file}"
  end
  
  desc "shows all the current reminder messages"
  task :show do
    run "if [ -e #{reminder_file} ]; then cat #{reminder_file}; fi"
  end
  
  desc "clears the current reminder messages"
  task :clear do
    run "rm #{reminder_file}"
  end
  
end