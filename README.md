# codptero  
Call of Duty Eggs for Pterodactyl Webpanel     
Available Eggs at the moment:    
Alterware (MW2, Ghosts, AW, BO3)

Plutonium (BO2, BO1, MW3, WAW)

Call of Duty 4x

Call of Duty MWR H1-Mod

Call of Duty 2

Call of Duty United Offensive

EZZ Boiii (Black Ops 3)


How to use IW4MAdmin in Pterodactyl:  
Create a new mount and assign it to the call of duty eggs and the iw4madmin egg, be sure to that the mount is writeable otherwhise it will not work.   
Use +set fs_homepath to set the new log dir for the call of duty server (example: +set fs_homepath "z:\codlogs\mw2" ; z: is the linux filesystem ; codlogs is the moung; mw2 is the folder for the gameserver)   
Set the correct log path in iw4madmin (for example /codlogs/mw2/logs/games_mp.log ; iw4madmin uses linux path system, because its runed by .net for linux).   
For configuration for iw4madmin check https://github.com/RaidMax/IW4M-Admin/wiki/Configuration   
    
For IW4MAdmin use the docker image attach here in this repo or from docker.io docker.io/draakoor/iw4madmin:latest if you want to edit the egg.

Note: For Call of Duty 4 you need to upload the game files to a mount, the files for Call of Duty 4 are not included in the egg.
