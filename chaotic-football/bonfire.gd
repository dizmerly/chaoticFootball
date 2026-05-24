extends Node2D

# Big picture view
# The bonfire allows the player to double tap 

# pass player id
var owned_by: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("abilities")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_bonfire(player_id, player_position):
#	Load and position the bonfire wherever the player is.
#	TODO make it so that bonfire is placed below the player,
# as in if he is in the air, find the closest solid surface below
# the player
	var bonfire = load("res://scenes/bonfire.tscn").instantiate()
	bonfire.global_position = player_position
	
	owned_by = player_id
