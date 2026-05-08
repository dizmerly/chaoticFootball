extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

#state machine 
enum States {IDLE, RUNNING, JUMPING}
var current_state = States.IDLE

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
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match current_state:
		States.IDLE:
			print("IDLE")
			if not is_on_floor():
				current_state = States.JUMPING
			if velocity.x != 0:
				current_state = States.RUNNING
		States.RUNNING:
			print("RUNNING")
			if not is_on_floor():
				current_state = States.JUMPING
			if velocity.x == 0:
				current_state = States.IDLE
		States.JUMPING:
			print("JUMPING")
			if is_on_floor():
				current_state = States.IDLE
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	position = position.round()
	
	
	
	
	
		
