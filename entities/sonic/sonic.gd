extends CharacterBody2D
class_name Sonic

@export var TOP_SPEED := 200.0
@export var ACCEL := 800.0
@export var INITIAL_JUMP_VELOCITY := -225.0
@export var HELD_JUMP_VELOCITY := -200.0
@export var FRICTION := 1000

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_pressed("jump"):
			velocity.y += HELD_JUMP_VELOCITY * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = INITIAL_JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * TOP_SPEED,
			ACCEL * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			FRICTION * delta
		)

	move_and_slide()
