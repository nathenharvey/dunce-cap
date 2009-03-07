## caplogfix.rb

# originally found at http://tinyurl.com/anfq5j
# contributed to a mailing list as a solution to cap logging, a dude named
# Dubeck shared it without a any license terms.  Dubeck, should you find this,
# I'd like to give you proper credit and disambiguate the license terms...

module Capistrano

 class MultiWriters
   Writer = Struct.new(:outstream, :needs_close)

   def initialize(f = nil)
     @writers = []
     add(f) if f
   end

   def add(f)
     if f.respond_to?(:puts)
       # This is an IO object
       @writers << Writer.new(f, false)
     else
       @writers << Writer.new(File.open(f, "w"), true)
     end
   end

   def close
     @writers.each { |w| w.outstream.close if w.needs_close }
   end

   def print(*args)
     @writers.each { |w| w.outstream.print(*args) }
   end

   def puts(*args)
     @writers.each { |w| w.outstream.puts(*args) }
   end

   def write(*args)
     @writers.each { |w| w.outstream.write(*args) }
   end
 end

 class Configuration
   #
   # Add a log output
   #
   puts "in configuration" + self.to_s
   def log(filename)
     @logdevice ||= MultiWriters.new(STDOUT)
     @logdevice.add(filename)

     save_level = @logger.level
     @logger.close
     @logger = Logger.new(:output => @logdevice)
     @logger.level = save_level
     @logger.info("Capistrano logging starts:
#{Time.now.utc}")
   end
 end

end
