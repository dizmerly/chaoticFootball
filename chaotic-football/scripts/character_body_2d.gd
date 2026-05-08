extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BALLDIST = 12

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

#ball handling
@onready var pickupArea = $BallPickup
var held_ball = null

func updateBallPos( dist):
	if held_ball == null:
		return
		
	var offset = Vector2(dist, 0)
		
	if sprite.flip_h:
		offset.x = -dist
		
	held_ball.position = offset

#state machine 
enum States {IDLE, RUNNING, JUMPING}
var current_state = States.IDLE

func _ready() -> void:
	add_to_group("player")
	pickupArea.body_entered.connect(_on_ball_pickup_body_entered)
	
func UpdateAnimation() -> void:
		match current_state:
			States.IDLE:
				anim.play("idle")
			States.RUNNING:
				anim.play("running")
			States.JUMPING:
				anim.play("jumping")

func _physics_process(delta: float) -> void:
	UpdateAnimation()
	var direction := Input.get_axis("left", "right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
#	handle whether character is going left or right
#	key point, the if statement here makes sure whatever the
#	most previous direction was, it stays that same direction
	if direction != 0:
		sprite.flip_h = direction < 0
	
#	State machine in order to handle different actions
	match current_state:
		States.IDLE:
			#print("IDLE")
			if not is_on_floor():
				current_state = States.JUMPING
			if velocity.x != 0:
				current_state = States.RUNNING
		States.RUNNING:
			#print("RUNNING")
			if not is_on_floor():
				current_state = States.JUMPING
			if velocity.x == 0:
				current_state = States.IDLE
		States.JUMPING:
			#print("JUMPING")
			if is_on_floor():
				current_state = States.IDLE
				
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
	#position = position.round()
	if held_ball != null:
		updateBallPos(BALLDIST)
			
	
func _on_ball_pickup_body_entered(body: Node2D) -> void:
	print("player interacts with", body)
	if body.is_in_group("ball") and held_ball == null:
		print("player touched the ball")
		held_ball = body
		held_ball.freeze = true 
		held_ball.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
		held_ball.set_collision_layer_value(3, false)
		held_ball.reparent(self)
		updateBallPos(BALLDIST)
