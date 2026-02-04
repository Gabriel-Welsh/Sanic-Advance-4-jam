extends CharacterBody2D
class_name Sonic

@onready var visuals := $Visuals

@export var TOP_SPEED := 200.0
@export var ACCEL := 400.0
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

	var direction := Input.get_axis("left", "right")
	if direction != 0:
		if sign(direction) != sign(velocity.x) && velocity.x != 0:
			velocity.x = move_toward(
				velocity.x,
				direction * TOP_SPEED,
				ACCEL * delta + FRICTION*delta
			)
		else:
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
	if is_on_floor():
		visuals.rotation = get_ground_angle()
	else:
		visuals.adrotation = 0
	
	move_and_slide()

func get_ground_angle() -> float:
	var normal := get_floor_normal()
	var tangent := Vector2(normal.y, -normal.x)
	return tangent.angle()
