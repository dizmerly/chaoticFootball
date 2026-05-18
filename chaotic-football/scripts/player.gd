extends CharacterBody2D


const SPEED = 300.0
const MAX_SPEED = 500.0
const RUN_SPEED_MULT = 1.1
const JUMP_VELOCITY = -400.0
const BALLDIST = 12
const SHOOTINGVELOCITY = 450.0
const BALL_HANDLING_DISTANCE = 12
const BALL_PICKUP_DELAY = 0.01

var device_num: int
var player_id: int


var button_bindings = {
	"interact": [JOY_BUTTON_X, KEY_F],
	"jump": [JOY_BUTTON_A, KEY_SPACE],
	"run": [JOY_BUTTON_B, KEY_SHIFT]
}

var axis_bindings = {
	"horizontal": [JOY_AXIS_LEFT_X],
	"vertical": [JOY_AXIS_LEFT_Y],
	"interact": [JOY_AXIS_TRIGGER_RIGHT],
	"jump" : [JOY_AXIS_TRIGGER_LEFT]
}


@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

#ball handling
@onready var pickupArea = $BallPickup
var held_ball = null

#state machine 
enum States {IDLE, RUNNING, JUMPING, HOLDING, THROWING}
var current_state = States.IDLE

var _is_roller = false

func _ready() -> void:
	add_to_group("player")
	pickupArea.body_entered.connect(_on_ball_pickup_body_entered)


func _input(event: InputEvent):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		#print("Using Mouse")
		_is_roller = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		#print("Using Controller")
		_is_roller = true
# 	Change UI to show controller prompts
	elif event is InputEventKey:
		#print("Using Keyboard")
		_is_roller = false
	
	if _is_roller:
		if event.device != device_num: return
		if not event is InputEventJoypadButton: return
		
		# Handle jump
		if event.button_index in button_bindings["jump"] and event.pressed:
			jump()
		#	shooting ball mechanics via interaction
		if event.button_index in button_bindings["interact"] and event.pressed:
			if held_ball != null:
				shoot_ball()
	else:
		if not event is InputEventKey: return
		if not event.pressed or event.echo: return
		
		if event.keycode in button_bindings["jump"]:
			jump()
		if event.keycode in button_bindings["interact"] and held_ball != null:
			shoot_ball()
		
		
# 0.2 deadzone here same as boilerplate
func apply_deadzone(value: float, deadzone: float = 0.2) -> float:
	if abs(value) < deadzone:
		return 0.0
	return sign(value) * (abs(value) - deadzone) / (1.0 - deadzone)


# get vector between (mouse) <--- (player position)
func get_mouse_dir() -> Vector2:
	var mousePos = get_global_mouse_position()
	var direction = mousePos - global_position
	return direction.normalized()

# get vector of joystick direction. fallback to default 45 degree shot
func get_stick_dir() -> Vector2:
	#var stickDir = Input.get_vector("left", "right",
	 #"up", "down")
	var stickDir = Vector2(
		apply_deadzone(Input.get_joy_axis(device_num, axis_bindings["horizontal"][0])),
		apply_deadzone(Input.get_joy_axis(device_num, axis_bindings["vertical"][0]))
		)
	if stickDir.length() > 0:
		return stickDir.normalized()
		
#	magic numbers here, simply hardcoded to shoot in direction
#	character is looking at	
	if sprite.flip_h:
		return Vector2(-1, 0).normalized()
	else:
		return Vector2(1, 0).normalized()

# updating ball position based on fixed distance
# basically a function to set where the ball is held by the player 
func update_ball_pos(dist):
	if held_ball == null:
		return
	
	var offset
	if _is_roller:
		offset = get_stick_dir() * BALL_HANDLING_DISTANCE
	else:
		offset = get_mouse_dir() * BALL_HANDLING_DISTANCE
		#
	#if sprite.flip_h:
		#offset.x = - dist
		
	held_ball.global_position = global_position + offset

	
func update_animation() -> void:
		match current_state:
			States.IDLE:
				anim.play("idle")
			States.RUNNING:
				anim.play("running")
			States.JUMPING:
				anim.play("jumping")

func jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func shoot_ball():
	pickupArea.monitoring = false
	
	
#	turning collisions back on
#	TODO: fix arbitrary values here, make sure that layers have 
#	actual variable names
	held_ball.set_collision_layer_value(3, true)
	held_ball.set_collision_mask_value(1, true)
#	reset velocity
	held_ball.linear_velocity = Vector2.ZERO
	held_ball.angular_velocity = 0
	
	var shoot_direction
	
#	find velocity vector
	if _is_roller:
		shoot_direction = get_stick_dir()
	else:
		shoot_direction = get_mouse_dir()
		
	held_ball.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	held_ball.freeze = false
	held_ball.apply_impulse(shoot_direction * SHOOTINGVELOCITY)
	

	held_ball = null
	await get_tree().create_timer(BALL_PICKUP_DELAY).timeout
	pickupArea.monitoring = true
	

func _physics_process(delta: float) -> void:
	update_animation()
	var direction = apply_deadzone(Input.get_joy_axis(device_num, axis_bindings["horizontal"][0]))
	
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
				

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
	#position = position.round()
			
#	handle whether user is using m&k or controller
	if held_ball != null:
		update_ball_pos(BALLDIST)
	
func _on_ball_pickup_body_entered(body: Node2D) -> void:
	#print("player interacts with", body)
	if body.is_in_group("ball") and held_ball == null:
		print("player picked up the ball")
#		assign ball to player
		held_ball = body
		held_ball.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
		held_ball.freeze = true
		held_ball.linear_velocity = Vector2.ZERO
		held_ball.angular_velocity = 0
		
#		assign the player id to ball to identify 
#		which player is holding the ball

		held_ball.held_by = player_id
		
		
#		freeze pauses the physics effects on the ball
#		along with reparent and updateBallPos setting 
#		the ball to a fixed distance in front of the player
		held_ball.set_collision_layer_value(3, false)
		
		held_ball.set_collision_mask_value(1, false)
		
		update_ball_pos(BALLDIST)
