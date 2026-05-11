extends Node

# Input pulls how many total controllers connected
var num_players = Input.get_connected_joypads().size()
var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_connection: int
#	this catches the signal of a new controller
#	assigns it some sort of value, that is stored in this 
#	new connection variable
	new_connection = Input.joy_connection_changed.connect(roller_connection_changed)



# changes of a controller connecting
func roller_connection_changed(device: int, connected: bool):
	if connected:
		num_players = Input.get_connected_joypads().size()
#		DEBUG
		print("Connected device {d}".format({"d":device}))
		add_player()
	else:
		pass
		# TODO: remove player function here in the future

func add_player():
	var Player = load("res://scenes/player.tscn")
	var player = Player.instantiate()
	players.append(player)
	print(players)
	
