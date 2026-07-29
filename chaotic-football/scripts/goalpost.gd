extends Node2D

@export var goalId: int = 0
signal scored(team: int)


# Assuming your child Area2D is named "GoalArea". If it's named something else,
# update the path here (e.g., $Area2D)
@onready var goalArea = $goalArea 

# Called when the node enters  the scene tree for the first time.
func _ready() -> void:
	# Connect the child Area2D's signal to a function in this script
	goalArea.body_entered.connect(_on_goal_area_body_entered)


func _on_goal_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("ball"):
		print("GOAL BY Player ", body.held_by, " !")
		
		# Emit the signal using this goalpost's goalId!
		scored.emit(goalId)
