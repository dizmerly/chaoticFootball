extends Control

@onready var blue_portrait: CenterContainer = $blue_portrait
@onready var red_portrait: CenterContainer = $red_portrait
#Texture Rects in the portraits
@onready var blue_image: TextureRect = $blue_portrait/blue_image
@onready var red_image: TextureRect = $red_portrait/red_image

#UI Buttons
@onready var left_blue: Polygon2D = $left_blue
@onready var right_blue: Polygon2D = $right_blue
@onready var left_red: Polygon2D = $left_red
@onready var right_red: Polygon2D = $right_red

var blue_index: int
var red_index: int



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
	if team_color == "blue":
		pass
	elif team_color == "red":
		pass
	else:
		print("Invalid team name") 
	
