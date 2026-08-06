extends Control

@onready var settings_menu: Control = $"Settings Menu"
@onready var popup_panel: Panel = $Panel
 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.hide()
	popup_panel.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_settings"):
		if popup_panel.visible:
			popup_panel.hide()
		elif settings_menu.visible:
			settings_menu.hide()
			popup_panel.show()
		else:
			popup_panel.show()
			
#		TODO: add support for moving around the menus with dpad


func _on_resume_button_pressed() -> void:
#	simply hide the panel
	print("Resumed")
	hide()

func _on_options_button_pressed() -> void:
#	show options menu
	print("Option Menu Opened")
	settings_menu.show()
	popup_panel.hide()
	
func _on_quit_to_menu_pressed() -> void:
#	close game scene and open the main menu
	print("Exited to main menu")
	pass # Replace with function body.

func _on_quit_to_desktop_pressed() -> void:
	get_tree().quit()
	
	
