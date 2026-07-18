extends Node2D

var teamAScore = 0
var teamBScore = 0

var WINNING_SCORE = 10



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if teamAScore >= WINNING_SCORE or teamBScore >= WINNING_SCORE:
		# win condition
		pass

func addPoint(team: int) -> void:
	# this is more or less a temporary easy solution here for now
	if team == 0:
		teamAScore += 1
		print("Added point to team A, ", teamAScore)
	elif team == 1:
		teamBScore += 1
		print("added point to team B, ", teamBScore)
		
func resetPoints() -> void:
	teamAScore = 0
	teamBScore = 0
