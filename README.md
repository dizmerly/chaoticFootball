
# Chaotic Football

A football game built in Godot, inspired by 2D football games and Super Smash Bros.-esque fighting games.

## Running the project on your machine

### Download

Download a prebuilt version of the project from the releases page:

- [Latest Release](https://github.com/dizmerly/chaoticFootball/releases/latest)
- [All Releases](https://github.com/dizmerly/chaoticFootball/releases)

#### Instructions

- Download the project.
- Depending on your operating system, it may warn that the application is not notarized. You can download the ZIP version instead. Windows, Linux, and macOS versions are available on the releases page.

### Quick Start Guide (Manual)

- Install Godot 4.7.
- Clone this repository.
- Open `chaotic-football/project.godot` in Godot.
- Confirm that the autoloads are configured.
- Set the main scene to `res://scenes/main_menu.tscn` if Godot has not already done so.
- Run the project.

### Verbose Version

#### Prerequisites

- Godot version 4.7
- Forward+ Rendering

Clone this repository and open it in Godot. Make sure that the global autoloads point to scripts in `chaotic-football/scripts`, as shown below.

<img width="939" height="238" alt="Global Scripts Filepaths" src="https://github.com/user-attachments/assets/ea85a79e-2a90-4710-bbeb-4d4226a497b4" />

Incorrect autoload paths will cause errors when you run the game. In the General tab, under **Application** > **Run**, make sure the main scene is set to `res://scenes/main_menu.tscn`.

<img width="939" height="238" alt="Run Configuration" src="https://github.com/user-attachments/assets/a568bf3a-69cf-4b03-b2fd-6835f13082bd" />

#### Playing with controller

The game detects connected controllers, but currently supports a maximum of two players. This is a temporary limit as of August 2026 and will be increased in the future. The first controller is mapped to the blue team, and the second is mapped to the red team.

#### Playing with mouse and keyboard

As of August 2026, mouse and keyboard play is available only through debug mode. Select Local Play, then press `Ctrl/Cmd + ]` (right bracket) to enter debug mode. This adds a player you can control with your mouse and keyboard.

#### August 2026
<p align="center">
  <video src="https://github.com/user-attachments/assets/8a8aa588-a16b-4700-a0ca-05b1e42dec1f" width="100%" controls></video>
</p>

#### May 2026
<img width="800" height="539" alt="demo" src="https://github.com/user-attachments/assets/7496060c-5efc-4b09-9f12-419cde46646c" />

## Controller Mapping
<img width="1920" height="1080" alt="Default" src="https://github.com/user-attachments/assets/fdb6660a-6c33-462d-9d91-26a8295bfef9" />

*Controller aiming uses the left stick. A future update will let players choose either left-stick aiming or separate right-stick aiming.*

## Keyboard Mapping

- `WASD` — Move
- Left Click — Interact / shoot
- Mouse — Aim
- `F` — Place and use ability

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
