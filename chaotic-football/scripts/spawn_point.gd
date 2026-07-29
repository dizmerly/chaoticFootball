extends Marker2D


var spawn_position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
