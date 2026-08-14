extends Control

@onready var blue_portrait: CenterContainer = $blue_portrait
@onready var red_portrait: CenterContainer = $red_portrait
#Texture Rects in the portraits
@onready var blue_image: TextureRect = $blue_portrait/blue_image
@onready var red_image: TextureRect = $red_portrait/red_image

#UI Buttons
var blue_index: int = 0
var red_index: int = 0

#UI Info
@onready var ready_red: Button = $ReadyRed
@onready var ready_blue: Button = $ReadyBlue

# Signals 
# TODO: either here or in game manger, once all controllers have
# emitted that they have selected a character, load the game.
signal character_selected(controller_id: int, spritesheet_path: String)


const CHARACTERS = [
	{
		"id": "spain",
		"portrait": preload("res://assets/SoccerGame/portraits/spainPortrait.png"),
		"spritesheet": "res://assets/SoccerGame/spainSpritesheet.png"
	},
	{
		"id": "argentina",
		"portrait": preload("res://assets/SoccerGame/portraits/argentinaPortrait.png"),
		"spritesheet" : "res://assets/SoccerGame/argentinaSpritesheet.png"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#eventually preferably store these as settings for user preferences
	blue_index = 0
	red_index = 0
	ready_red.hide()
	ready_blue.hide()
	
	load_image(red_index, "red")
	load_image(blue_index, "blue")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_image(image_index: int, team_color: String) -> void:
	if image_index < 0 or image_index >= CHARACTERS.size():
		push_error("Invalid character index, %d" % image_index)
		return
	var character = CHARACTERS[image_index]
	var portrait: Texture2D = character["portrait"]
	
	if team_color == "blue":
		blue_image.texture = portrait
	elif team_color == "red":
		red_image.texture = portrait
	else:
		push_error("Invalid team color %s" % team_color)

func confirm_selection(controller_id: int, image_index: int) -> void:
	if image_index < 0 or image_index >= CHARACTERS.size():
		push_error("Invalid character index: %d" % image_index)
		return

	character_selected.emit(
		controller_id,
		CHARACTERS[image_index]["spritesheet"]
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		var controller_id = event.device
		
#		Confirm ready
		if event.button_index == JOY_BUTTON_A and event.is_pressed():
			if controller_id in GameManager.blue_team:
				confirm_selection(controller_id, blue_index)
				ready_blue.show()
			elif controller_id in GameManager.red_team:
				confirm_selection(controller_id, red_index)
				ready_red.show()
#		Cycle left and right
		if event.button_index == JOY_BUTTON_DPAD_LEFT and event.is_pressed():
			if controller_id in GameManager.blue_team:
				cycle_blue_left()
			elif controller_id in GameManager.red_team:
				cycle_red_left()
		if event.button_index == JOY_BUTTON_DPAD_RIGHT and event.is_pressed():
			if controller_id in GameManager.blue_team:
				cycle_blue_right()
			elif controller_id in GameManager.red_team:
				cycle_red_right()
#		Cancel Ready
		if event.button_index == JOY_BUTTON_B and event.is_pressed():
			if controller_id in GameManager.blue_team:
				ready_blue.hide()
			if controller_id in GameManager.red_team:
				ready_red.hide()

func cycle_blue_left() -> void: 
	if ready_blue.hidden:
		blue_index = wrapi(blue_index - 1, 0, CHARACTERS.size())
		load_image(blue_index, "blue")
				
func cycle_blue_right() -> void: 
	if ready_blue.hidden:
		blue_index = wrapi(blue_index + 1, 0, CHARACTERS.size())
		load_image(blue_index, "blue")

func cycle_red_left() -> void:
	if ready_red.hidden: 
		red_index = wrapi(red_index - 1, 0, CHARACTERS.size())
		load_image(red_index, "red")

func cycle_red_right() -> void: 
	if ready_red.hidden:	
		red_index = wrapi(red_index + 1, 0, CHARACTERS.size())
		load_image(red_index, "red")
