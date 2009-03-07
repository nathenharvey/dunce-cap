module CapUtils
  def ask(key, question, default=nil)
    if self[key].nil?
      
        if question =~ /password|passwd/i
            set key, Capistrano::CLI.password_prompt("#{question} (#{default.to_s}): ")
        else
            printf "#{question} (#{default.to_s}): "; STDOUT.flush
            set key, STDIN.readline.chomp
        end
        
        if self[key] == "" and not default.nil?
            self[key] = default
        end
    end
  end
end

Capistrano.plugin :caputils, CapUtils