extends Node

# Controller state that must survive scene changes.
var connected_controllers: Array[int] = []
var pending_devices: Array[int] = []

# Temporary team assignments for character-select testing.
var blue_team: Array[int] = [0]
var red_team: Array[int] = [1]

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
	controller_disconnected.emit(device)
