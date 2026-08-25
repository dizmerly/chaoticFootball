extends Node2D

@onready var settings_menu: Control = $"CanvasLayer/Settings Menu"
@onready var menu_buttons: Array[Button] = [
	$"VBoxContainer/Local Multiplayer",
	$"VBoxContainer/Online Multiplayer",
	$"Settings",
	$"Quit"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.hide()
	for button in menu_buttons:
		button.mouse_entered.connect(button.grab_focus)
	menu_buttons[0].grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if settings_menu.visible:
		return

	if event.is_action_pressed("dpad_down"):
		_move_menu_focus(1)
	elif event.is_action_pressed("dpad_up"):
		_move_menu_focus(-1)

func _move_menu_focus(direction: int) -> void:
	var current_index := menu_buttons.find(get_viewport().gui_get_focus_owner())
	var next_index := 0 if current_index == -1 else posmod(current_index + direction, menu_buttons.size())
	menu_buttons[next_index].grab_focus()

func _on_settings_pressed() -> void:
	settings_menu.show()

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/character_selection_panel.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
