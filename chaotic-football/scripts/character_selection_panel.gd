extends Control

@onready var blue_portrait: CenterContainer = $blue_portrait
@onready var red_portrait: CenterContainer = $red_portrait
#Texture Rects in the portraits
@onready var blue_image: TextureRect = $blue_portrait/blue_image
@onready var red_image: TextureRect = $red_portrait/red_image

#UI Buttons



var blue_index: int
var red_index: int


signal character_selected(controller_id: int, spritesheet_path: String)


const CHARACTERS = [
	{
		"id": "spain",
		"portrait": preload("res://assets/SoccerGame/spainSpritesheet.png"),
		"spritesheet": "res://assets/SoccerGame/spainSpritesheet.png"
	},
	{
		"id": "argentina",
		"portrait": preload("res://assets/SoccerGame/argentinaSpritesheet.png"),
		"spritesheet" : "res://assets/SoccerGame/argentinaSpritesheet.png"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#eventually preferably store these as settings for user preferences
	blue_index = 0
	red_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_image(image_index: int, team_color: String) -> void:
	if image_index < 0 or image_index > CHARACTERS.size():
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
		if event.button_index == JOY_BUTTON_A and event.pressed:
			var controller_id := event.device
			if controller_id == 0:
				confirm_selection(controller_id, blue_index)
			elif controller_id == 1:
				confirm_selection(controller_id, red_index)
