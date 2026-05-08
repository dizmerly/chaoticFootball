extends Camera2D


@onready var player = $"../Player"
@onready var ball = $"../Ball"

const MIN_ZOOM = 1.5
const MAX_ZOOM = 4.0 
const ZOOM_DISTANCE = 400.0 
const MARGIN = 1.05
var margin = 20 #px


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dist = ball.global_position.distance_to(player.global_position) * MARGIN
	var t = clamp(dist/ZOOM_DISTANCE, 0.0, 1.0)
	t = pow(t, 2)
	var target_zoom = lerp(MAX_ZOOM, MIN_ZOOM, t)
	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), 5 * delta)
	
	
	limit_left = min(player.global_position.x, ball.global_position.x) - margin
	limit_right = max(player.global_position.x, ball.global_position.x) + margin
	
