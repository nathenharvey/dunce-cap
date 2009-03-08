after "deploy", "reminders:show"

namespace :reminders do
  def reminder_file
   "#{shared_path}/system/reminders.txt"
  end
  
  task :add do  
    caputils.ask :reminder, "Reminder: "
    run "echo \"user: #{user}\" >> #{reminder_file}"
    run "echo \"On: #{Time.new.to_s}\" >> #{reminder_file}"
    run "echo \"Message: #{reminder}\" >> #{reminder_file}"
    run "echo \"\n\" >> #{reminder_file}"
  end
  
  task :show do
    run "if [ -e #{reminder_file} ]; then cat #{reminder_file}; fi"
  end
  
  task :clear do
    run "rm #{reminder_file}"
  end
  
end