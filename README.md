
# Chaotic Football

A football game built in Godot. The inspiration behind this game is 2d football games, along with super smash bro esque fighting games. 

## Running the project on your machine 

### Download
Download a prebuilt version of the project from the release
- [Latest Release](https://github.com/dizmerly/chaoticFootball/releases/latest)
- [All Releases](https://github.com/dizmerly/chaoticFootball/releases)

#### Instructions
- Downlaod the project
- Depending on your OS, it may complain that it isn't a notarized file. If you would like to just download the zip version, feel free to do so as well. Version for Windows, Linux, and macOS are all available in the release page. 

### Quick Start Guide (Manual) 
- Install Godot version 4.7 onto your machine
- Clone this repository
- Open chatotic footaball project in godot (route filepath to _project.godot_)
- Confirm autolaods are enabled
- Set the main scene to `res://scenes/main_menu.tscn` if Godot has not already done so.
- Run the project 

### Verbose Version
#### Prerequisites
- Godot version 4.7
- Forward+ Rendering

Clone this repository and open it in Godot, make sure that you have 
properly configured globals from the chaoticFootball/chaotic-football/scripts directory. 
It should look something like this: 
<img width="939" height="238" alt="Global Scripts Filepaths" src="https://github.com/user-attachments/assets/ea85a79e-2a90-4710-bbeb-4d4226a497b4" />

If configured incorrectly, it will cause errors whenver trying to run the game. 
In the General tab, make sure that under **Application** | **Run**, the main scene is set to `res://scenes/main_menu.tscn`.

<img width="939" height="238" alt="Run Configuration" src="https://github.com/user-attachments/assets/a568bf3a-69cf-4b03-b2fd-6835f13082bd" />


#### Playing with controller
The controller detection can connect an arbitrary number of controllers. However, currently, the limit
is hardcoded to a maximum of 2 controllers. This a temporary limit as of August 2026, and will be increased in the future. The first controller is mapped to the blue team, the second controller is mapped to the red team. 


#### Playing with mouse and keyboard
Whenver you start the game, as of August 2026, the only way to use mouse, is by pressing Local Play, 
and then pressing Ctrl/Cmd + ] (right bracket) on your keyboard to enter debugMode. Entering debugMode 
places a player in the game tree that you can control with your mouse and keyboard. 

#### August 2026
<p align="center">
  <video src="https://github.com/user-attachments/assets/8a8aa588-a16b-4700-a0ca-05b1e42dec1f" width="100%" controls></video>
</p>

#### May 2026
<img width="800" height="539" alt="demo" src="https://github.com/user-attachments/assets/7496060c-5efc-4b09-9f12-419cde46646c" />

## Controller Mapping
<img width="1920" height="1080" alt="Default" src="https://github.com/user-attachments/assets/fdb6660a-6c33-462d-9d91-26a8295bfef9" />
*On controller, aiming is done with the left stick (in future, a feature will be added to allow the user to select left stick aiming, or aiming separately with right stick. 

## Keyboard Mapping
WASD - Move
Left Click - Interact / Shooting
Mouse - Aiming
F - Place and use ability.

## Project documentation

- [Game design](docs/game_design.md)
- [Architecture](docs/architecture.md)
- [Known issues](docs/known_issues.md)
- [Changelog](CHANGELOG.md)

## Roadmap

- Online multiplayer
- Map selection
- More characters and abilities
- Goal celebrations and animations
- Level editor (potentially)

## License
This project is source-available under the Chaotic Football Non-Commercial Modding License.
You may play with, mod, fork, and share it for free. You must credit the original project, 
keep derivatives non-commercial, and you cannot use the game's name or branding for your own release.

