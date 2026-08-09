extends Control

@onready var panel: Panel = $Panel

const CHARACTERS = [
	{
		"id": "spain",
		"portrait": preload("res://assets/SoccerGame/playerTwo.png")
	},
	{
		"id": "argentina",
		"portrait": preload("res://assets/SoccerGame/playerOne.png")
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
