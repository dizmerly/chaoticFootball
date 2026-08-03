extends CharacterBody2D


const SPEED = 470.0
const MAX_SPEED = 600.0
const ACCELERATION = 1200
#Eventually, this friction value should depend on the surface player is on
const FRICTION = 3000
const DRAG = 900
const JUMP_VELOCITY = -400.0
const BALLDIST = 12
const BALL_HANDLING_DISTANCE = 12
const BALL_PICKUP_DELAY = 0.1
const BALL_REPOSSESSION_DELAY = 0.1
const DEADZONE = 0.5
const REPOSSESSION_MULTIPLIER = 0.69

const SHOOTING_RUMBLE_DURATION = 0.2

var device_num: int
var player_id: int

var button_bindings = {
	"interact": [JOY_BUTTON_X, KEY_F],
	"jump": [JOY_BUTTON_A, KEY_SPACE],
	"run": [JOY_BUTTON_B, KEY_SHIFT],
	"useAbility": [JOY_BUTTON_Y],
	"summonAbility": [JOY_BUTTON_DPAD_UP]
}

var axis_bindings = {
	"horizontal": [JOY_AXIS_LEFT_X],
	"vertical": [JOY_AXIS_LEFT_Y],
	"interact": [JOY_AXIS_TRIGGER_RIGHT],
	"jump" : [JOY_AXIS_TRIGGER_LEFT]
}

var right_trigger_actuated: bool = false
var left_trigger_actuated: bool = false


@onready var sprite: Sprite2D = $"Player Skin"
@onready var anim = $AnimationPlayer

@onready var shockwave_frames: Sprite2D = $Repossess/ShockwaveFrames
@onready var shockwave_animation: AnimationPlayer = $Repossess/ShockwaveAnimation


#ball handling
@onready var pickupArea = $BallPickup
var held_ball = null

@onready var repossessArea = $Repossess
var trying_repossession: bool = false

#state machine 
enum States {IDLE, RUNNING, JUMPING, HOLDING, THROWING}
var current_state = States.IDLE

var _is_roller = false

@onready var ray = $ClosestGround
@onready var ball_ray = $BallRayCast
var abilities: Array = []


func _ready() -> void:
	add_to_group("player")
	pickupArea.body_entered.connect(_on_ball_pickup_body_entered)
	#repossessArea.body_entered.connect(_on_reposess_body_entered)
	shockwave_animation.animation_finished.connect(func(anim_name): 
		shockwave_frames.hide())


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
		
		# Handle joypad buttons
		if event is InputEventJoypadButton:
			# Handle jump
			if event.button_index in button_bindings["jump"] and event.pressed:
				jump()
			#	shooting ball mechanics via interaction
			if event.button_index in button_bindings["interact"] and event.pressed:
				if held_ball != null:
					shoot_ball()
				else:
					repossess()
#				play shockwave animation for interaction
				shockwave_frames.show()
				shockwave_animation.play("shockwave")
				#interaction vibration/rumble
				Input.start_joy_vibration(device_num, 0.5, 0.5, SHOOTING_RUMBLE_DURATION)
				
				
			if event.button_index in button_bindings["summonAbility"] and event.pressed:
				abilities[0].summon()
			
			if event.button_index in button_bindings["useAbility"] and event.pressed:
				abilities[0].use()
		if event is InputEventJoypadMotion:
#			these comments are mainly here to find code quicker with ctrl + F
#			jumping
			if event.axis in axis_bindings["jump"] and event.axis_value > DEADZONE \
			and !left_trigger_actuated:
				left_trigger_actuated = true
				jump()
			elif event.axis in axis_bindings["jump"] and event.axis_value < DEADZONE:
				left_trigger_actuated = false
				
#			trigger motions shooting	
			if event.axis in axis_bindings["interact"] \
			and event.axis_value > DEADZONE and !right_trigger_actuated:
				right_trigger_actuated = true
				if held_ball != null:
					shoot_ball()
				else:
					repossess() 
#				shockwave animation for interaction
				shockwave_frames.show()
				shockwave_animation.stop()
				shockwave_animation.play("shockwave")
				
				#interaction vibration
				Input.start_joy_vibration(device_num, 0.5, 0.5, SHOOTING_RUMBLE_DURATION)
			elif event.axis in axis_bindings["interact"] and event.axis_value < DEADZONE:
				right_trigger_actuated = false


	else:
		if not event is InputEventKey: return
		if not event.pressed or event.echo: return
		
		if event.keycode in button_bindings["jump"]:
			jump()
		if event.keycode in button_bindings["interact"]:
			if held_ball != null:
				shoot_ball()
			else:
				repossess()
		
		
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
		
	ball_ray.target_position = offset
	ball_ray.force_raycast_update()
	
#	TODO this magic number, what is does the 5.5 do?? 
	if ball_ray.is_colliding():
		held_ball.global_position = ball_ray.get_collision_point() \
		+ ball_ray.get_collision_normal() * 5.5
	else:
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
	var direction = get_stick_dir() if _is_roller else get_mouse_dir()
	
	var shot_ball = held_ball
#	These collision exceptions do make ball collisions more correct, but removes ball jumping.
	#shot_ball.add_collision_exception_with(self)
	
	shot_ball.shoot(direction)
	held_ball = null
	
	await get_tree().create_timer(BALL_PICKUP_DELAY).timeout
	pickupArea.monitoring = true
	
	#if is_instance_valid(shot_ball):
		#shot_ball.remove_collision_exception_with(self)

func repossess():
	var bodies = repossessArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("ball") and held_ball == null:
			if body.held_by != null:
				

				var ball_owner
				var players = get_tree().get_nodes_in_group("player")
				for p in players:
					if p.player_id == body.held_by:
						ball_owner = p
				ball_owner.held_ball = null
				body.held_by = null
				var direction = get_stick_dir() if _is_roller else get_mouse_dir()
				
				
#				probably really stupid solution here, TODO fix this in the future
				body.add_collision_exception_with(ball_owner)
				ball_owner.pickupArea.monitoring = false
				pickupArea.monitoring = false
				body.shoot(direction, REPOSSESSION_MULTIPLIER)
				await get_tree().create_timer(BALL_REPOSSESSION_DELAY).timeout
				

				
				body.remove_collision_exception_with(ball_owner)
				ball_owner.pickupArea.monitoring = true
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
	#
	#if direction != 0 and not is_on_floor():
		#velocity.x 	= move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * 2  * delta)
	#elif direction != 0:
		#velocity.x 	= move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	#elif is_on_floor():
		#velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	#else:
		#velocity.x = move_toward(velocity.x, 0, DRAG * delta)
	
#	Raw speed movement
 
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
		 

	move_and_slide()
	#position = position.round()
	if held_ball != null:
		update_ball_pos(BALLDIST)
	
func _on_ball_pickup_body_entered(body: Node2D) -> void:
	#print("player interacts with", body)
	if body.is_in_group("ball") and held_ball == null:
		#print("player picked up the ball")
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
