require 'filewatcher'
require 'fileutils'
require 'sys/proctable'
require 'parseconfig'
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
      if (File.size(@a3) > 221434)
        begin
          print "console.log was over the recommended size upon closure! remaking console.log....\n"
          FileUtils.rm(@a3)
          FileUtils.touch(@a3)
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
  a1 = data["directory_name"]
  a2 = data["source"]
  a2 = a2.gsub(/\\/,'/')
  @a3 = data["console_watch"]
  @a3 = @a3.gsub(/\\/,'/')
  a4 = data["destination"]
  map_names = ['ar_baggage', 'ar_monastery', 'ar_shoots', 'cs_agency', 'cs_assault', 'cs_backalley', 'cs_compound',
  'cs_downtown', 'cs_insertion', 'cs_italy', 'cs_militia', 'cs_motel', 'cs_office', 'cs_rush', 'cs_seaside',
  'cs_thunder', 'cs_workout', 'de_ali', 'de_aquarium_061815_v2', 'de_aztec', 'de_bank', 'de_bazaar', 'de_blackgold',
  'de_cache', 'de_castle', 'de_cbble', 'de_dust', 'de_dust2', 'de_facade', 'de_favela', 'de_inferno', 'de_lake',
  'de_log', 'de_marquis', 'de_mirage', 'de_mist', 'de_nuke', 'de_overgrown', 'de_overpass', 'de_rails', 'de_rails',
  'de_resort', 'de_safehouse', 'de_seaside', 'de_season', 'de_shortdust', 'de_shorttrain', 'de_stmarc', 'de_sugarcane',
  'de_train', 'de_vertigo', 'de_zoo', 'gd_assault', 'gd_bank', 'gd_cbble', 'gd_crashsite', 'gd_lake']
  catcher = []
  if File.exists?(@a3)
    print "console.log exists! continung with script... \n"
    sleep 1
  else
    print "console.log doesn't exist! creating one...\n"
    FileUtils.touch(@a3)
    sleep 1
  end
  if File.exists?(a2)
    print "demo.dem exists! continung with script... \n"
    sleep 1
  else
    print "demo.dem doesn't exist! creating one...\n"
    FileUtils.touch(a2)
    sleep 1
  end
  if File.exists?(a1)
    print "demos folder exists! continung with script... \n"
    sleep 1
  else
    print "demos folder doesn't exist! creating one...\n"
    Dir.mkdir(a1)
    sleep 1
  end
  FileWatcher.new(["#{a2}"], true).watch do |filename, event|
    if(event == :new)
      puts "Added file: " + filename
    end
    if(event == :changed)
      files = Dir["#{a2}"].collect{|f| File.expand_path(f)}
      demo_time = "#{catcher[-1]}_#{Time.now.strftime("%H%M%S" + "_" + "%Y%m%d")}.dem"
      File.readlines(@a3).grep(/Map:/).map do |line|
        catcher.concat(line.split.map(&:to_s))
      end
      puts "File updated: " + filename
      if (File.size(filename) > 1)
        files.each do |filename|
          puts "Copying file #{demo_time} to demo directory."
          FileUtils.cp filename, "#{a4}/#{demo_time}"
          puts "Watching file #{a2}"
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
