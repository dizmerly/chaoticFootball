extends Node

@onready var ball: RigidBody2D = $Map/Ball

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_board() -> void: 
	#resets the board and the ball towards their starting positions.
	ball.global_position = ball.inital_position
	ball.linear_velocity = Vector2.ZERO
	ball.angular_velocity = 0.0
