extends CharacterBody2D
class_name Sonic

@onready var visuals := $Visuals

@export var TOP_SPEED := 200.0
@export var ACCEL := 400.0
@export var INITIAL_JUMP_VELOCITY := -225.0
@export var HELD_JUMP_VELOCITY := -200.0
@export var FRICTION := 1000
@export var ROTATION_SPEED := 5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_pressed("jump"):
			velocity.y += HELD_JUMP_VELOCITY * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		var normal := get_floor_normal()
		print("normal: ", normal)
		var tangent := Vector2(normal.x, -normal.y)
		print("tangent: ", tangent)
		print("velocity old: ", velocity)
		velocity += tangent*INITIAL_JUMP_VELOCITY
		print("velocity new: ", velocity)

	var direction := Input.get_axis("left", "right")
	if direction != 0:
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
	# if not tyring to move
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			FRICTION * delta
		)
	#
	if is_on_floor():
		visuals.rotation = move_toward(visuals.rotation,
			get_ground_angle(),
			ROTATION_SPEED * 5 * delta)
	else:
		visuals.rotation = move_toward(visuals.rotation,
			0,
			ROTATION_SPEED * delta)
		print("velocity new new: ", velocity)
	
	move_and_slide()

## returns the angle (in radians) tangent to the ground
func get_ground_angle() -> float:
	var normal := get_floor_normal()
	var tangent := Vector2(-normal.y, normal.x)
	return tangent.angle()
