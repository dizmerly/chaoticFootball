# Changelog

All notable changes to Chaotic Football will be documented in this file.

## v0.1.0-alpha 
Date 09/01/2026

### Added

- Added instructions for running the project on your machine with Godot 4.7 and Forward+ rendering.
- Added setup notes for configuring the global scripts and setting `res://scenes/main_menu.tscn` as the main scene.
- Added notes for controller play: controller detection can connect an arbitrary number of controllers, but the game is currently hardcoded for two.
- Added mouse and keyboard debug mode instructions using `Ctrl/Cmd + ]` from Local Play.

## Development history prior to v0.1.0-alpha

The following is retroactively documented from commit history, and the file devlog.md.

### August 2026

#### Added

- Added controller rumble and fixed triggers activating twice.
- Added a settings menu and popup menus that save user configurations, including brightness controls.
- Added character-selection panels, portraits, player skin support, controller-based selection, and team ready states.
- Completed full local-game flow: Main Menu → Local Play → Character Selection → Game.
- Added selected character skins to the players when the game loads.
- Added match-ending logic: the game returns to the main menu when a team reaches 10 points.
- Added a debug game start, mouse and keyboard support for debug mode, double jump, and jump-cut functionality.
- Added the cyberpunk-theme asset set.

#### Changed

- Moved controller tracking into the game manager.
- Cleaned up code comments and improved menu input handling.

### July 2026

#### Added

- Added a working scoreboard that updates when a goal is scored.
- Added controller confirmation and the ability to press A to join.
- Added ball resetting after a goal.

### May–June 2026

#### Added

- Added player movement, throwing direction, multiple controller input detection, and per-device controls.
- Added a dynamic camera that centers around the players and the ball.
- Added ball possession so the game can track which player scored.
- Added trigger jumping, ball shooting logic in the ball script, the Bonfire ability, and repossession.
- Added a basic main menu and new background work.

#### Fixed

- Fixed goalpost collision by increasing the physics tick speed to 120 and using continuous collision detection.
- Fixed character speed increasing unexpectedly because of position rounding.
- Fixed buggy wall collisions.
