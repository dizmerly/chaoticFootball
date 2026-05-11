extends Camera2D


#TODO: fix the player variable here to be an 
#array that tracks all the players
#and modify camera script to average it's position
#based on all player positions and the ball
#centering itself at the ball's position. 
@onready var player = $"../Player"
@onready var ball = $"../Ball"

const MIN_ZOOM = 1.5
const MAX_ZOOM = 4.0 
const ZOOM_DISTANCE = 400.0 
const MARGIN = 1.2
var margin = 20 #px


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	var dist = 0.0
	if player.held_ball == ball:
		dist = 0
	else:
		dist = ball.global_position.distance_to(player.global_position) * MARGIN
	
	var t = clamp(dist/ZOOM_DISTANCE, 0.0, 1.0)
	t = pow(t, 2)
	var target_zoom = lerp(MAX_ZOOM, MIN_ZOOM, t)
	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), 5 * delta)
	
	var midpoint = (player.global_position + ball.global_position) / 2.0
	global_position = global_position.lerp(midpoint, 5 * delta)
	
