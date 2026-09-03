# Project Architecture

## File Structure

```
chaoticFootball/  
├── chaotic-football/ 
│   ├── .vscode/
│   ├── addons/
│   │   └── GDTerminal/
│   ├── assets/       
│   │   ├── cyberpunk_theme/
│   │   ├── fonts/
│   │   └── SoccerGame/
│   │       ├── portraits/
│   │       └── ui_assets/
│   ├── scenes/
│   └── scripts/
└── docs/
```

## Overview
Chaotic Football is a 2D multiplayer football game built in Godot 4.7. The game is primarily written in GDScript, and all scenes are made with the Godot Engine. 

## Project layout

- `chaotic-football/scenes/` Godot scenes.
- `chaotic-football/scripts/` GDScript attached to scenes.
- `chaotic-football/assets/` sprites, backgrounds, fonts, and other art.
- `docs/` project documentation.

## Global systems
The project has two scripts that autoload
`settings_manager.gd` - loads and saves user settings, initializes settings config if one is not found.
`game_manager.gd` - controls controller connection, adding players, controlling team - player assignments, loading the game scene

## Main game flow (september 2026)

1. Upon starting the project, game laods into `main_menu.tscn`.
2. Local Play opens character selection.
3. Each controller selects a character.
4. `GameManager` confirms that both teams are ready.
5. Godot loads `game.tscn`.
6. The game scene creates players, manages the ball, scoreboard, camera, and goals.
7. When a team reaches the score threshold, the game returns to the main menu, and one of the teams wins. (sept 2026, currently the winning team is just output to the console.)

## Important scenes

- `main_menu.tscn` is the starting menu.
- `character_selection_panel.tscn` lets players select a character.
- `game.tscn` runs an active match.
- `player.tscn` represents one player and their movement, input, ball handling,
  and abilities.
- `ball.tscn` manages the football physics and possession.
- `scoreboard.tscn` displays and tracks scores.
- `settings.tscn` and `popup_settings_menu.tscn` manage game settings, `settings.tscn` calls settings_manager when loading and saving settings

## Gameplay Systems

### Players and input
Each player has a controller ID. `player.gd` reads input only from that controller.
Mouse and keyboard play currently works through debug mode.

### Ball and scoring

Players can possess, shoot, and repossess the ball. Goal detection updates the
scoreboard. After a goal, the game resets for kickoff.

### Abilities

Abilities are separate scenes. The current ability is Bonfire (yes the reference is intended). The game scene
creates an ability instance for each player and assigns ownership using the
player's controller ID.

## Current limitations

- Local multiplayer is currently limited to two players.
- Mouse and keyboard play is currently intended for debug mode.
- Online multiplayer and map selection are not implemented yet.

