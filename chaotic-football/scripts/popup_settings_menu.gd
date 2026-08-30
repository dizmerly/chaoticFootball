extends Control

@onready var settings_menu: Control = $"Settings Menu"
@onready var popup_panel: Panel = $Panel
 
@onready var resume_button: Button = $Panel/VBoxContainer/resume_button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for child in $Panel/VBoxContainer.get_children():
		if child is Button:
			child.mouse_entered.connect(child.grab_focus)

	settings_menu.hide()
	popup_panel.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		_on_resume_button_pressed()
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("open_settings"):
		if popup_panel.visible:
			close_popup()
		elif settings_menu.visible:
			settings_menu.hide()
			open_popup()
		else:
			open_popup()
		get_viewport().set_input_as_handled()


func _on_resume_button_pressed() -> void:
#	simply hide the panel
	print("Resumed")
	close_popup()

func _on_options_button_pressed() -> void:
#	show options menu
	print("Option Menu Opened")
	settings_menu.show()
	popup_panel.hide()
	$"Settings Menu/VBoxContainer/volume_label/volume_slider".grab_focus()
	
func _on_quit_to_menu_pressed() -> void:
#	close game scene and open the main menu
	print("Exited to main menu")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_to_desktop_pressed() -> void:
	get_tree().quit()

#opening and closing the popup settings
#menu grabs and releases focus for controls.
func open_popup() -> void:
	get_tree().paused = true
	popup_panel.show()
	resume_button.grab_focus()

func close_popup() -> void:
	settings_menu.hide()
	popup_panel.hide()
	get_viewport().gui_release_focus()
	get_tree().paused = false
	
	
