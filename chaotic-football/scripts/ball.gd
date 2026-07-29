extends RigidBody2D


@onready var player = $"../Player"

var held_by

const SHOOTINGVELOCITY = 450.0

var initial_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("ball")
	initial_position = global_position

func shoot(direction: Vector2, speed_multiplier = 1):
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	freeze = false
	apply_impulse(direction * SHOOTINGVELOCITY * speed_multiplier)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	pass

func reset() -> void:
	global_position = initial_position
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
