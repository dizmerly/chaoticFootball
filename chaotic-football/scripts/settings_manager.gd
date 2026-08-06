extends Node

# settings values
# (0-100)
var master_volume: int
var sfx_volume: int
var brightness: int
# (0-2) 0 - fullscreen, 1 - windowed, 2 - borderless
var window_mode: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func save_settings() -> void:
	pass

func load_settings() -> void:
	pass
