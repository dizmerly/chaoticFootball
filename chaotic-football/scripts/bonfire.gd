extends Node2D

# Big picture view
# The bonfire allows the player to double tap 

# pass player id
var owned_by: int
var active: bool
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("abilities")
	visible = false
	active = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func summon():
#	TODO make it so that bonfire is placed below the player,
# as in if he is in the air, find the closest solid surface below
# the player
	if(player == null):
		var players = get_tree().get_nodes_in_group("player")
	
		for p in players:
			if p.player_id == owned_by:
				player = p
	
	var ground_point
	if player.ray.is_colliding():
		ground_point = player.ray.get_collision_point()
	
	
	if ground_point != null:
		global_position = ground_point
		visible = true
		active = true	
	else:
		print("[WARNING] FAILED TO SUMMON")
	
func use():
	if(player == null):
		var players = get_tree().get_nodes_in_group("player")
	
		for p in players:
			if p.player_id == owned_by:
				player = p
				
	if active: 
		active = false
		visible = false
		if player.held_ball != null:
			player.drop_ball()
		player.global_position = global_position
