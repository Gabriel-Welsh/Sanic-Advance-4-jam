extends CharacterBody2D
class_name Sonic

@onready var visuals := $Visuals

@export var TOP_SPEED := 200.0
@export var ACCEL := 400.0
@export var INITIAL_JUMP_VELOCITY := 200.0
@export var HELD_JUMP_VELOCITY := 175.0
@export var FRICTION := 1000.0
@export var AIR_FRICTION := FRICTION/25
@export var ROTATION_SPEED := 5.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	handle_sonic_movement_input(delta)
	
	handle_sonic_rotation_to_ground(delta)
	
	move_and_slide()

## Handles all movement inputs (very messy lol)
func handle_sonic_movement_input(delta: float) -> void:
	# Handle jump.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_pressed("jump"):
			velocity.y -= HELD_JUMP_VELOCITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		var normal := get_floor_normal()
		velocity += normal * INITIAL_JUMP_VELOCITY
	
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		if is_on_floor():
			# if trying to move in the opposite direction of current velocity
			if sign(direction) != sign(velocity.x) && velocity.x != 0:
				velocity.x = move_toward(
					velocity.x,
					direction * TOP_SPEED,
					ACCEL * delta + FRICTION*delta
				)
			# if trying to move in the same direction of current velocity
			else:
				velocity.x = move_toward(
					velocity.x,
					direction * TOP_SPEED,
					ACCEL * delta
				)
		else:
			if sign(direction) != sign(velocity.x) && velocity.x != 0:
				velocity.x = move_toward(
					velocity.x,
					direction * TOP_SPEED,
					ACCEL * delta + AIR_FRICTION*delta
				)
			# if trying to move in the same direction of current velocity
			else:
				velocity.x = move_toward(
					velocity.x,
					direction * TOP_SPEED,
					ACCEL * delta
				)
	# if not tyring to move
	else:
		if is_on_floor():
			velocity.x = move_toward(
				velocity.x,
				0,
				FRICTION * delta
			)
		else:
			velocity.x = move_toward(
				velocity.x,
				0,
				FRICTION/25 * delta
			)

func handle_sonic_rotation_to_ground(delta: float):
	if is_on_floor():
		visuals.rotation = move_toward(visuals.rotation,
			get_ground_angle(),
			ROTATION_SPEED * 2 * delta)
	else:
		visuals.rotation = move_toward(visuals.rotation,
			0,
			ROTATION_SPEED * delta)

## returns the angle (in radians) tangent to the ground
func get_ground_angle() -> float:
	var normal := get_floor_normal()
	var tangent := Vector2(-normal.y, normal.x)
	return tangent.angle()
