# codptero  
Call of Duty Eggs and Quake3 Games for Pterodactyl Webpanel     
Available Eggs at the moment:    
Alterware (MW2, Ghosts, AW, BO3)  
Plutonium (BO2, BO1, MW3, WAW)  
Call of Duty 4x  
Call of Duty MWR H1-Mod  
Call of Duty 2  
Call of Duty United Offensive  
EZZ Boiii (Black Ops 3)  
Moviebattles 2 Mod (Jedi Academy)


How to use IW4MAdmin in Pterodactyl:  
Mount method:
Create a new mount and assign it to the call of duty eggs and the iw4madmin egg, be sure to that the mount is writeable otherwhise it will not work.
Update your wings config and restart.
Also see here: https://pterodactyl.io/guides/mounts.html
Use +set fs_homepath to set the new log dir for the call of duty server (example: +set fs_homepath "z:\codlogs\mw2" ; z: is the linux filesystem ; codlogs is the mount; mw2 is the folder for the gameserver)   => Note only required if its not working for g_log does not set drive z: (z: is the linux filesystem)
Set the correct log path in iw4madmin (for example /codlogs/mw2/logs/games_mp.log ; iw4madmin uses linux path system, because its runed by .net for linux).   
For configuration for iw4madmin check https://github.com/RaidMax/IW4M-Admin/wiki/Configuration

Hardlinks method:
Create a iw4madmin instance, create a new folder for example gamelogs in that instance.  
Connect to your machine via ssh => navigate with cd to the volume (should be in /var/lib/pterodactyl/volumes) of your cod server.  
Look for your games_mp.log and go the folder.  (use "find" if you dont know where it is)
create a hardlink to your iw4madmin instance like: games_mp.log /var/lib/pterodactyl/volumes/UUID of IW4MADMIN/gamelogs/logname.log  
Change your iw4madmin config to the new logpath for example /home/container/codlogs/t6mp.log  
    
For IW4MAdmin use the docker image attach here in this repo or from docker.io docker.io/draakoor/iw4madmin:latest if you want to edit the egg.

Note: For Call of Duty 4 you need to upload the game files to a mount, the files for Call of Duty 4 are not included in the egg.

Note for IW4M-Admin: The docker image will change after the new version comes out for dotnet8

Note Moviebattles2: RTV/RTM is included!
