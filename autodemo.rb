require 'filewatcher'
require 'fileutils'
require 'sys/proctable'
require 'inifile'
include Sys

def processKill
  # this sleep is for compiled usage, comment it out if you're using the ruby script
  sleep 8
  @csgo = []
  ProcTable.ps{ |w|
    @csgo.push(w.pid) if w.cmdline =~ /csgo/i
  }
  loop do
    sleep 5
    ProcTable.ps{ |w|
      @csgo.push(w.pid) if w.cmdline =~ /csgo/i
    }
    if (@csgo.empty?)
      if (File.size(@console_watch) > 221434)
        begin
          print "console.log was over the recommended size upon closure! remaking console.log....\n"
          FileUtils.rm(@console_watch)
          FileUtils.touch(@console_watch)
          sleep 2
        end
      end
      print "CSGO is not open or was closed! ending script!\n"
      sleep 2
      abort
    end
    @csgo.clear
  end
end

def demoWatcher
  # this sleep is for compiled usage, comment it out if you're using the ruby script
  sleep 8
  ini = IniFile.load("config.ini")
  data = ini["CSGO Demo Directory"]
  directory_name = data["directory_name"]
  source = data["source"]
  source = source.gsub(/\\/,'/')
  @console_watch = data["console_watch"]
  @console_watch = @console_watch.gsub(/\\/,'/')
  destination = data["destination"]
  catcher = []
  if File.exists?(@console_watch)
    print "console.log exists! continung with script... \n"
    sleep 1
  else
    print "console.log doesn't exist! creating one...\n"
    FileUtils.touch(@console_watch)
    sleep 1
  end
  if File.exists?(source)
    print "demo.dem exists! continung with script... \n"
    sleep 1
  else
    print "demo.dem doesn't exist! creating one...\n"
    FileUtils.touch(source)
    sleep 1
  end
  if File.exists?(directory_name)
    print "demos folder exists! continung with script... \n"
    sleep 1
  else
    print "demos folder doesn't exist! creating one...\n"
    Dir.mkdir(directory_name)
    sleep 1
  end
  FileWatcher.new(["#{source}"], true).watch do |filename, event|
    if(event == :new)
      puts "Added file: " + filename
    end
    if(event == :changed)
      files = Dir["#{source}"].collect{|f| File.expand_path(f)}
      demo_time = "#{catcher[-1]}_#{Time.now.strftime("%H%M%S" + "_" + "%Y%m%d")}.dem"
      File.readlines(@console_watch).grep(/Map:/).map do |line|
        catcher.concat(line.split.map(&:to_s))
      end
      puts "File updated: " + filename
      if (File.size(filename) > 1)
        files.each do |filename|
          puts "Copying file #{demo_time} to demo directory."
          FileUtils.cp filename, "#{destination}/#{demo_time}"
          puts "Watching file #{source}"
        end
      end
    end
    if(event == :delete)
      puts "File deleted: " + filename
    end
  end
end

t1=Thread.new{processKill()}
t2=Thread.new{demoWatcher()}
t1.join
t2.join
