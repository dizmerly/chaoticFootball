extends Camera2D


#TODO: fix the player variable here to be an 
#array that tracks all the players
#and modify camera script to average it's position
#based on all player positions and the ball
#centering itself at the ball's position. 
var players = []
@onready var ball = $"../Ball"

const MIN_ZOOM = 1.5
const MAX_ZOOM = 4.0 
const ZOOM_DISTANCE = 400.0 
const MARGIN = 1.2
var margin = 20 #px


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#dist = ball.global_position.distance_to(player.global_position) * MARGIN
	
	#find the player that is further from the ball, and zoom in respect to that
	var max_dist = 0.0
	var furthestPlayer = null
	if !players.is_empty():
		for p in players:
			var dist = ball.global_position.distance_to(p.global_position)
			if dist > max_dist: # find furthest distance
				max_dist = dist
				furthestPlayer = p
	max_dist = max_dist * MARGIN
	
	var t = clamp(max_dist/ZOOM_DISTANCE, 0.0, 1.0)
	t = pow(t, 2)
	var target_zoom = lerp(MAX_ZOOM, MIN_ZOOM, t)
	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), 5 * delta)
	

	var midpoint
	if furthestPlayer != null:
		midpoint = (furthestPlayer.global_position + ball.global_position) / 2.0
	else:
		midpoint = (ball.global_position) 
	global_position = global_position.lerp(midpoint, 5 * delta)
	
