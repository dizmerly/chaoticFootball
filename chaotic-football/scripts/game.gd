extends Node

# Input pulls how many total controllers connected
var num_players = Input.get_connected_joypads().size()
var players: Array = []
var input_maps: Array = []

#reference to camera
@onready var camera = $Camera2D

# later on, alter this to where you prepend the location of scene instead of hardcoded
# i.e. instead of "BONFIRE" : "res://scenes/bonfire.tscn", it should be
# "BONFIRE" : "bonfire.tscn"
var abilities = {"BONFIRE" : "res://scenes/bonfire.tscn"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_connection: int

#	this catches the signal of a new controller
#	assigns it some sort of value, that is stored in this 
#	new connection variable
	new_connection = Input.joy_connection_changed.connect(roller_connection_changed)
	if Input.get_connected_joypads().size() == 0:
#		Debug player, meant for mouse and keyboard.
		add_player(-1)



# changes of a controller connecting
func roller_connection_changed(device: int, connected: bool):
	if connected:
		num_players = Input.get_connected_joypads().size()
#		DEBUG
		#print("Connected device {d}".format({"d":device}))
		add_player(device)
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
	
func remove_player(player_index):
	pass
	#remove_child()
	
	
