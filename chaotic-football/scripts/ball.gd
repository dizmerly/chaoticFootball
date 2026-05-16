extends RigidBody2D


@onready var player = $"../Player"

var held_by = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("ball")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	pass
