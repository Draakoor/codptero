# codptero  
Games for Pterodactyl Webpanel     
Available Eggs at the moment:    
Titanfall 2 (Northstar Client)  
Sven Coop  
Project Shield (Black Ops 4 Demonware Server)  
Alterware (MW2, Ghosts, AW)  
Plutonium (BO2, BO1, MW3, WAW)  
Call of Duty 4x  
Call of Duty MWR H1-Mod (not working at the moment - we are waiting for linux support, alternative: https://github.com/dockur/windows)  
Call of Duty MWR H2-Mod (test state, download it and give feedback)  
Call of Duty 2  
Call of Duty United Offensive  
T7x (Use this for hosting, https://github.com/Draakoor/codptero/blob/main/eggs/egg-t7x.json)  
Moviebattles 2 Mod (Jedi Academy) with RTM/RTV  
  
You need to get the gamefiles by yourself and own the game/have a license (piracy is not supported and will never be!!!!!)!  
  
How to use IW4MAdmin in Pterodactyl:  
  
Hardlinks method:  
Create a iw4madmin instance, create a new folder for example gamelogs in that instance.  
Connect to your machine via ssh => navigate with cd to the volume (should be in /var/lib/pterodactyl/volumes) of your cod server.  
Look for your games_mp.log and go the folder.  (use "find" if you dont know where it is)  
create a hardlink to your iw4madmin instance like: games_mp.log /var/lib/pterodactyl/volumes/UUID of IW4MADMIN/gamelogs/logname.log  
Change your iw4madmin config to the new logpath for example /home/container/codlogs/t6mp.log  
  
Game Log Server method:  
Use eggs where game log servers is included!  
INFO: Sometimes you need to add the manuel log path too! for example: z:/home/container/Plutonium/storage/t6/main/logs/games_mp.log  
  
  
Images are splitted to github (https://github.com/Draakoor?tab=packages&repo_name=codptero) and docker (https://hub.docker.com/u/draakoor)  


Windows:
Ports: 8006 (For VNC), 3389 (For RDP)
  
Note: Not all eggs have a working console (output and/or commands working), feel free to pull request.
