extends Control

@onready var settings_menu: Control = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_resume_button_pressed() -> void:
#	simply hide the panel
	hide()

func _on_options_button_pressed() -> void:
#	show options menu
	pass # Replace with function body.

func _on_quit_to_menu_pressed() -> void:
#	close game scene and open the main menu
	pass # Replace with function body.

func _on_quit_to_desktop_pressed() -> void:
	get_tree().quit()
