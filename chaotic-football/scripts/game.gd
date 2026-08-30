# main game manager

extends Node

var players: Array = []
var input_maps: Array = []
var player_ids: Array = []

var GOAL_RUMBLE_DURATION = 1 #seconds

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
@onready var spawn_point_1: Marker2D = $"Map/Spawn Point 1"
@onready var spawn_point_2: Marker2D = $"Map/Spawn Point 2"

#REFERENCE TO WorldEnvironment
@onready var world_environment: WorldEnvironment = $Map/WorldEnvironment



func _ready() -> void:
	GameManager.controller_join_requested.connect(_on_controller_join_requested)
	if not GameManager.pending_devices.is_empty():
		join_popup.show()
	
	
	#connect settings
	SettingsManager.brightness_changed.connect(_on_brightness_changed)
	_on_brightness_changed(SettingsManager.brightness)

# PLAYER CONNECTION CONTROL

func _on_controller_join_requested(_device: int) -> void:
	join_popup.show()
	# Temporary fix to remove the keyboard player when a controller joins.
	remove_player(-1)

func add_player(player_index, ability_selection = "bonfire"):
	# Applying player attributes
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
	
	# add player to tree and append them to the 
	# player array connected to camera
	add_child(player)
	if player_index in GameManager.blue_team:
		player.global_position = spawn_point_1.global_position
	elif player_index in GameManager.red_team:
		player.global_position = spawn_point_2.global_position

	players.append(player)
	camera.players.append(player) # add player to list collection in camera
	player.load_playerskin(GameManager.selected_characters[player_index])
	
	
	print(players)
	
func remove_player(player_index):
	var players = get_tree().get_nodes_in_group("player")
	var player
	for p in players:
		if p.player_id == player_index:
			player = p
			
	remove_child(player)
	
	
# HUD CONTROL	
func score_goal(team:int):
	scoreboard.addPoint(team)
	await get_tree().create_timer(3) #seconds
#	check if any teams have reached the point threshold to win
	var result: String = scoreboard.winning_team()
	if result != "none":
		if result == "blue":
			print("Blue won!")
		elif result == "red":
			print("Red won!")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
		
	ball.reset.call_deferred()
	#rumble every controller connected upon goal scored
	for id in player_ids:
		Input.start_joy_vibration(id, 0.7, 0.7, GOAL_RUMBLE_DURATION)
	if players.size() > 0:
		players[0].global_position = spawn_point_1.global_position
	if players.size() > 1:
		players[1].global_position = spawn_point_2.global_position

func _on_goalpost_scored(team: int) -> void:
	score_goal(team)

func _on_goalpost_2_scored(team: int) -> void:
	score_goal(team)

func _on_controller_confirmation_pressed_a(controller_id: int) -> void:
	if controller_id in GameManager.pending_devices:
		add_player(controller_id)
		player_ids.push_back(controller_id)
		GameManager.pending_devices.erase(controller_id)
	if GameManager.pending_devices.is_empty():
		join_popup.hide()

func _on_brightness_changed(value: float) -> void:
	# Slider 0–100 becomes a sensible game brightness range.
	world_environment.environment.adjustment_brightness = value
	
func game_end():
	print("Game over")
