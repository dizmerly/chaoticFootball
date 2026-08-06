extends Control

@onready var volume_slider: HSlider = $VBoxContainer/volume_label/volume_slider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#	TODO: allow menu navigation with dpad etc, also take focus of the controllers to
#	pause player movement if online multiplayer, if local multiplayer, freeze the game 
#	scene


func _on_volume_slider_value_changed(value: float) -> void:
	var db_value = linear_to_db(value)
	var master_bus_index = 0
	AudioServer.set_bus_volume_db(master_bus_index, db_value)


func _on_sfx_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_brightness_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_option_button_item_selected(index: int) -> void:
	pass # Replace with function body.
