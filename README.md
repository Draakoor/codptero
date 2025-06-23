# 🎮 codptero

**Game server eggs for the [Pterodactyl Webpanel](https://pterodactyl.io)**  
⚠️ _You must own the games and obtain the game files yourself. Piracy is not supported and never will be!_

---

## 📦 Available Eggs

- **Titanfall 2** (Northstar Client, manual upload required because mount)  
- **Sven Co-op**  (steamcmd)
- **Project Shield** (Black Ops 4 Demonware Server, github release)  
- **Alterware** (MW2, Ghosts, AW)   (custom ftp url)  
- **Plutonium** (BO2, BO1, MW3, WaW)   (custom ftp url)  
- **Call of Duty 4x** (uses mount for files, manual upload required)  
- **Call of Duty MWR Engine**  (steamcmd)
  - IW7-Mod (Infinite Warfare)
  - H1-Mod  
  - H2M/HMW  
- **Call of Duty 2**  (custom ftp url)  
- **Call of Duty: United Offensive**  (custom ftp url) 
- **T7x**  (uses steamcmd for mp, zombies need manual uploading)  
  - [Use this JSON egg for hosting](https://github.com/Draakoor/codptero/blob/main/eggs/egg-t7x.json)
- **Jedi Academy** (Vanilla, TaystJK, OpenJK with steamcmd) 
- **Jedi Outcast** (Vanilla, JK2MV with steamcmd)
- **Movie Battles 2 Mod** (Jedi Academy with steamcmd)  
  - Includes RTV/RTM support  

---

## 🧠 IW4MAdmin in Pterodactyl

### 🔗 Method 1: Hardlinks

1. Create an IW4MAdmin instance.
2. Inside that instance, create a folder (e.g., `gamelogs`).
3. SSH into your machine and navigate to your COD server's volume:  
   `/var/lib/pterodactyl/volumes/UUID-of-server`
4. Locate your `games_mp.log` file (use `find` if necessary).
5. Create a **hardlink**:  
   ```bash
   ln /path/to/games_mp.log /var/lib/pterodactyl/volumes/UUID-of-IW4MAdmin/gamelogs/logname.log
   ```
6. Update your IW4MAdmin config to use the new log path, e.g.:  
   `/home/container/codlogs/t6mp.log`

### 📱 Method 2: Game Log Server

- Use eggs that already include game log server support.
- Python based: https://github.com/RaidMax/IW4MAdmin-GameLogServer/releases
- Rust based: https://github.com/Draakoor/iw4m-log-server/releases
- **Sometimes you must manually set the log path**, for example:  
  `z:/home/container/Plutonium/storage/t6/main/logs/games_mp.log`

---

## 🐳 Docker & GitHub Packages

- **GitHub Packages**: [Draakoor's Packages](https://github.com/Draakoor?tab=packages&repo_name=codptero)  
- **Docker Hub**: [draakoor on Docker](https://hub.docker.com/u/draakoor)

---

## 🧪 HMW-Mod (MWR)

A working egg for the **H2M/HMW mod** is now available!  
> ⚠️ Note: You cannot mount `/home/container/H2M` **before** server creation. You must:
> 1. Stop the server installation.
> 2. Stage the mount.
> 3. Restart installation.

### Details

- **Steam** is installed via **Winetricks**.
- Steam runs once to install required updates.
- Optional mounts:
  - H2M/HMW: `/home/container/H2M`
  - H1-Mod: `/home/container/h1mod`

> 🧪 _Note: Not all eggs support full console output or input. Pull requests to improve them are very welcome!_  
> _You will not get any support, when you have lack of basic linux knowledge_

---

## 🧰 AMP Templates

Templates for AMP (Application Management Panel) are available here:  
🔗 [AMP Templates - dev branch](https://github.com/Draakoor/AMPTemplates/tree/dev)
