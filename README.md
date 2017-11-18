# HEX - Dark Fantasy Arena
Public release of HEX.

* **For HEX support**, you can add me on Steam http://steamcommunity.com/id/Demonkush
* I will only provide support with the unmodified gamemode. I can provide pointers on how to modify it, but I will not help you fix it if you broke it yourself.


# What is HEX?
Part Arena Shooter, part RPG Shooter; inspired by games like Hexen and Unreal Tournament. With several different gametypes you can experience HEX in all sorts of flavors. Use magical weapons and items to destroy your enemies and steal their gold, or work toward a goal together in team-based gametypes. All in one gamemode!


# How to Setup HEX
* **Install addon and gamemode.** ( These work for the most part without configuration )
* **Install content.** ( Make sure model content is on your server. Content not included, get it from the workshop! )
* **Install map data.** ( place the hex data folder in 'garrysmod/data' )
* **Install maps.** ( All of the maps I've created for HEX, Soulwind and Lment are included in GitHub. )

* -OPTIONAL- Setup MYSQL ( The gamemode has mysql support, refer to init.lua )
* **NOTE: With MYSQL disabled, stats will not save.**
* **NOTE: Content not included in GitHub, download the addons from the workshop and extract the data from the .gma.**


# Main Features
* **Dynamic Gametype System** ( changes the way HEX is played )
* **Elemental Damage and RPG Damage System** ( critical strikes, fire damage, variable damage, etc )
* **Built-in Map Vote System** ( accounts for voted gametype and picks applicable maps )
* **MYSQL Support** ( Saves player level and exp. (LEVEL = RANK not power) )
* **HEX Weapon System** ( 4 attacks per weapon. **Low Power**, **Normal**, **High Power** (Overpowered), **Special** (Magesoul) )
* **Current Gametypes** ( Skirmish, Team Skirmish, Elder, Greed, Scavenger, Mountain Man )
* and lots more!

# Content
**HEX Collection**
* http://steamcommunity.com/sharedfiles/filedetails/?id=1132883167 - Contains all you need for the game itself.

**EXTRA Content** ( player models )
* http://steamcommunity.com/sharedfiles/filedetails/?id=320793184 - War40k Cultist
* http://steamcommunity.com/sharedfiles/filedetails/?id=263221318 - DOTA2 Skeleton King
* http://steamcommunity.com/sharedfiles/filedetails/?id=306283778 - Knight Solaire ( *disabled by default )
* http://steamcommunity.com/sharedfiles/filedetails/?id=460772855 - Zeus
* http://steamcommunity.com/sharedfiles/filedetails/?id=294457005 - Auron
* http://steamcommunity.com/sharedfiles/filedetails/?id=416440184 - Sylvanas
* http://steamcommunity.com/sharedfiles/filedetails/?id=524867600 - Palutena ( *disabled by default )

*I've disabled these models in-game by default. They were either too large or I felt were not fitting.


# Things to Know
* I am releasing HEX to the public because I am working on other projects right now, and feel bad about letting this project stagnate.
* **HEX is NOT complete.** It's playable, but overall it still needs a lot of work. I hope you guys can still have fun with it!
* Feel free to modify the gamemode to your liking, but **DO NOT upload to the workshop or anywhere else!!!** IT is not a workshop ready addon and requires extra setup to play. **ONLY download from GITHUB (here)!**
* You are allowed to fork this repository ( if not, let me know ). The main repo will only be updated by myself; I will decide if your changes are acceptable.
* The gamemode is kind of a mess. If I don't provide documentation in the future, you can ask me for assistance.
* Most configuration is found in the shared tables. With basic lua knowledge you can create new elements, items and more!
* When adding new maps, you also must place spawn data on the map and create a map icon which is downloaded by clients manually.
* I may have forgotten some things. Please let me know if the gamemode is completely busted, or if you have trouble understanding me.
* The Powerup system is an incomplete feature. You may see Powerups show up, but do not function properly. You can disable them in `sh_maintable`.

# Credits
* Demonkush - Mapping, Lua, some graphics for UI / particles
* Heretic / Hexen - Some degree of inspiration.
* Warcraft - Using some sound effects from the games, some weapon models, good deal of influence from the games as well.
* Morrowind - Using weapon models from a model pack.
* Crashlemon - Some useful lua and for always being such a great friend
* 017 - Created some models for me, ported some WoW models like guns / crossbows
* Xeno-cide - Created a landmine model.
* XMPStudios - For supporting me and allowing me to host my selfish projects on their box. ( I am no longer involved with XMPStudios )
