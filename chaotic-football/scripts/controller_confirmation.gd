extends Control


signal pressed_a(controller_id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A: 
			pressed_a.emit()
	else:
		print("not a button on joypad")
