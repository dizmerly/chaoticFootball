# main game manager

extends Node

# Input pulls how many total controllers connected
var num_players = Input.get_connected_joypads().size()
var players: Array = []
var input_maps: Array = []

# Array for processing connected controllers
var pending_devices: Array = []
@onready var join_popup: Panel = $Map/CanvasLayer/JoinPopup


#reference to camera
@onready var camera = $Map/Camera2D

#reference to scoreboard
@onready var scoreboard = $Map/CanvasLayer/Control/VBoxContainer/Control
# later on, alter this to where you prepend the location of scene instead of hardcoded
# i.e. instead of "BONFIRE" : "res://scenes/bonfire.tscn", it should be
# "BONFIRE" : "bonfire.tscn"
var abilities = {"BONFIRE" : "res://scenes/bonfire.tscn"}

#REFERENCES TO OBJECTS IN GAME
@onready var ball: RigidBody2D = $Map/Ball
@onready var spawn_point_1: Marker2D = $"Spawn Point 1"




func _ready() -> void:
	Input.joy_connection_changed.connect(roller_connection_changed)
	
	# Get a list of all controllers currently plugged in right now
	var connected_rollers = Input.get_connected_joypads()
	
	if connected_rollers.size() == 0:
		# Keep your debug keyboard code
		add_player(-1)
	else:
		# Loop through the already connected controllers!
		for roller_id in connected_rollers:
			pending_devices.append(roller_id)
			
		# Since there are people waiting, show the popup right away!
		join_popup.show()



# PLAYER CONNECTION CONTROL 

# adds players to an array that tracks which devices havent yet been connected
func roller_connection_changed(device: int, connected: bool):
	if connected:
		num_players = Input.get_connected_joypads().size()
#		DEBUG
		#print("Connected device {d}".format({"d":device}))
		
		# make a popup in the ui for the player to press a to confirm
		
		
		pending_devices.append(device)
		
		join_popup.show()
		
#		temporary fix to remove keyboard player. 
		remove_player(-1)
	else:
		pass
		# TODO: remove player function here in the future

func add_player(player_index, ability_selection = "bonfire"):
	#TODO
	#add code here that controls what abilities the players have access to. 
	var player = load("res://scenes/player.tscn").instantiate()
	player.device_num = player_index
	player.player_id = player_index
	
	# Adding player abilities
	
	var player_abilities: Array = []
	if abilities.has(ability_selection.to_upper()):
		var ability = load(abilities[ability_selection.to_upper()]).instantiate()
		add_child(ability)
		ability.owned_by = player.player_id
		player_abilities.append(ability)
	else:
		print("[WARNING] Bad String for ability")
		
	player.abilities = player_abilities
	
	add_child(player)
	players.append(player)
	camera.players.append(player) # add player to list collection in camera
	
	
	print(players)
	
#TODO add a remove player function. 
func remove_player(player_index):
	var players = get_tree().get_nodes_in_group("player")
	var player
	for p in players:
		if p.player_id == player_index:
			player = p
			
	remove_child(player)
	
	
# HUD CONTROL	
	
func _on_goalpost_scored(team: int) -> void:
	scoreboard.addPoint(team)
	ball.reset.call_deferred()
	players[0].global_position = spawn_point_1.global_position
	

func _on_goalpost_2_scored(team: int) -> void:
	scoreboard.addPoint(team)
	ball.reset.call_deferred()
	players[0].global_position = spawn_point_1.global_position



func _on_controller_confirmation_pressed_a(controller_id: int) -> void:
	if controller_id in pending_devices:
		add_player(controller_id)
		pending_devices.erase(controller_id)
	join_popup.hide()
