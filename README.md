# CSGO-autodemo

## Description
CSGO-autodemo is a Ruby script for Counter-Strike: Global Offensive to help record and manage demo files. Because Valve doesn't currently have a system in place to automatically record POV (player perspective) demos with unique file names, the script helps remedy that. The script actively watches the default CSGO directory for demo updates and parses the console.log to copy and move completed demos to a demos directory.


## Dependencies
 Requires Ruby and RubyGems installed to work correctly
* [FileWatcher] - Filewatcher scans the filesystem and execute shell commands when files are updated, added, renamed or deleted.
* [sys-proctable] - A Ruby interface for gathering process information on your operating system
* [inifile] - A Ruby package for reading and writing INI files


## How It Works
The script starts by getting the process ID of the CSGO application, this is so it will know when CSGO closes so it can abort the script. The script checks for a console.log to read from and see if there is a demos folder created, it creates one if there isn't. After it's done that it watches (by default) the CSGO folder for a demo file to be created/updated/deleted. Upon creation and deletion there will be an output of the actions happening in real time. Once it's updated, which happens when the demo is done recording, it start's the copy and rename process. The script scrapes console.log for the last map name, which is the map the demo was recorded on. After doing so the script simply goes back to watching for the file to be updated again to do it all over again. Upon exiting the CSGO application, the script will check if the console.log is over a certain size, which can cause problems with the naming convention, and abort and close. 


## Script Features
* creates a "demos" folder to store demos in a saner fashion
* automatically renames demo based on map name it was recorded on and time, e.g. demo.dem becomes de_overpass_032110_20151018.dem
* console.log parsing for map name
* if console.log is over a certain size, which can cause problems when parsing, it deletes it and creates a new one
* aborts script upon closure of the CSGO process


## Usage
* Before running the script ensure that you have "-condebug" (without quotes) enabled in the launch options (Steam Library -> Right click Counter-Strike: Global Offensive -> Click properties -> Set launch options..) under CSGO. This enables logging to a console.log file which is how the filename for the demo is generated. It will not work unless you have this enabled.
<p align="center">
  <img src="https://i.imgur.com/iJqMjB8.png" alt="CSGO Launch Options"/>
</p>
* By default, the script runs off of the default CSGO installation directory. This is easily changed in the script by updating the config.ini with your current CSGO installation directory.

```sh
; edit in the path for your OS. default Windows C installation:
[CSGO Demo Directory]
directory_name = C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\demos
source = C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\demo.dem
console_watch = C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\console.log
destination = C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\demos/

; if custom installation location, change the drive letter and comment out the above and remove #'s below
# [CSGO Demo Directory]
# directory_name = D:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\csgo\demos
# source = D:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\csgo\demo.dem
# console_watch = D:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\csgo\console.log
# destination = D:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\csgo\demos/
```
* To use efficiently, pair this script with a simple CSGO autoexec bind. Simply copy this bind to your autoexec.cfg and when you're in a game, press f2 once to start the recording of the demo and again when you wish to stop it. Leaving the server or game also stops recording a demo.

```sh
bind f2 "record_demo"
alias record_demo "record demo; bind f2 r_demo"
alias r_demo "stop; bind f2 record_demo"
```
* The script automatically aborts once the CSGO process has been closed.

For more information on how to make an autoexec config, visit - http://autoexec.global-offensive.com/


# Example Usage
<p align="center">
  <img src="https://i.imgur.com/AlQRLFp.png" alt="Example Usage of Script"/>
</p>

# Compiled Usage

* You can compile the script into a working application (.exe) that simply requires running it after CSGO is started to work. The advantages of this is no command line usage. Everything is included in the application and no dependencies are needed. You can compile it yourself, you'll need to do this if you have a custom Steam installation directory, or you can download a premade one from below.

#### Instructions

To compile it yourself you'll need the [ocra] gem and have CSGO running. If the compile stalls while CSGO is open, simply close CSGO and it should continue.

```sh
gem install ocra
ocra --add-all-core --console autodemo.rb
```

# Precompiled Usage
<p align="center">
  <img src="https://i.imgur.com/b1NnGvL.png" alt="Precompiled Application Usage Example"/>
</p>

* The advantages of using a precompiled source is that you don't need ruby or any of the dependencies installed to run. You simply download the application and run it either with a BAT file or start it after you've started CSGO. The application is very small and will silently close after you've quit CSGO.

# BAT File
* Simply edit the BAT file depending on which version of the application you need. Anytime you want to run them together, just run the file.
```sh
@echo off
start steam://rungameid/730
start "" "C:\PATH\TO\autodemo.exe"
```

## Precompiled link
* The link includes a readme.txt, an output of the ocra compile process and MD5 hash, a config.ini and a BAT file which you will need to edit.
* [Download here] 
* 
# Common Issues
* Sometimes on the first run of the application, when the console.log is empty, the demo will rename without a map name, e.g. -> _063807_20151018.dem. Temporarily you can just quickly record and stop a demo and upon next try at recording a demo it should work fine.
* Because the script applies a process ID under the capture of "csgo", if you have another application starting with "csgo", be it the CSGO directory or something else, it could associate with that program instead of CSGO. Close out of anything that falls under that category before you start the application/script.
* Currently won't name demos from custom maps that fall outside of the [map_names array] with their map name, I will add a better system in the future


# Todo
* fix the above



   [FileWatcher]: <https://github.com/thomasfl/filewatcher>
   [sys-proctable]: <https://github.com/djberg96/sys-proctable>
   [inifile]: <https://github.com/TwP/inifile>
   [Ruby]: <https://www.ruby-lang.org/en/>
   [RubyGems]: <https://rubygems.org/>
   [ocra]: <https://github.com/larsch/ocra>
   [Download here]: <https://www.mediafire.com/?rw7wty7imiwvopl>
   [map_names array]: <https://github.com/rybro/csgo-autodemo/blob/master/autodemo.rb#L37-L43>
