extends Node

# controller states 
var connected_controllers: Array[int] = []
var pending_devices: Array[int] = []

#temporary hardcoded team assignmnets
var blue_team: Array[int] = [0]
var red_team: Array[int] = [1]

# Team ready status (potentially revise this solution)
# KEY : VALUE = team : bool (ready or not ready)
var teams: Dictionary = {
	"blue": false,
	"red": false,
}

#KEY : VALUE = CONTROLLER ID : SPRITE_SHEET
var selected_characters: Dictionary = {}
var is_loading_game := false
var debug_player_requested := false


# Game Managment signals
signal controller_join_requested(device: int)
signal controller_disconnected(device: int)



func _ready() -> void:
	for device in Input.get_connected_joypads():
		connected_controllers.append(device)
		pending_devices.append(device)
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected:
		if device in connected_controllers:
			return

		connected_controllers.append(device)
		pending_devices.append(device)
		controller_join_requested.emit(device)
		return

	connected_controllers.erase(device)
	pending_devices.erase(device)
	blue_team.erase(device)
	red_team.erase(device)
	selected_characters.erase(device)
	_update_team_ready_status()
	controller_disconnected.emit(device)

func _on_character_selected(controller_id: int, spritesheet_path: String) -> void:
	selected_characters[controller_id] = spritesheet_path
	_update_team_ready_status()

#	check for all teams being ready and load game.
#	eventually this will map to a map selection screen
	if teams_ready():
		load_game()
	

func unselect_character(controller_id: int) -> void:
	selected_characters.erase(controller_id)
	_update_team_ready_status()

func _update_team_ready_status() -> void:
	teams["blue"] = _is_team_ready(blue_team)
	teams["red"] = _is_team_ready(red_team)

func _is_team_ready(team: Array[int]) -> bool:
	if team.is_empty():
		return false

	for controller_id in team:
		if controller_id not in selected_characters:
			return false

	return true

func teams_ready() -> bool:
	for team in teams:
		if not teams[team]:
			return false
	return true

func load_game() -> void:
	if is_loading_game:
		return

	is_loading_game = true
#	Arbitrary 1 second wait for here temporarily TODO change this later
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
