extends CharacterBody2D
class_name Sonic

@onready var visuals := $Visuals

@export var TOP_SPEED := 300.0
@export var ACCEL := 200.0
@export var INITIAL_JUMP_VELOCITY := 200.0
@export var HELD_JUMP_VELOCITY := 175.0
@export var FRICTION := 1000.0
@export var AIR_FRICTION := FRICTION/20
@export var ROTATION_SPEED := 5.0

var sonic_is_on_floor: bool = true

func _physics_process(delta: float) -> void:
	sonic_is_on_floor = is_on_floor()
	
	handle_sonic_jump(delta)
	
	handle_sonic_left_right_movement(delta)
	
	handle_sonic_rotation_to_ground(delta)
	
	move_and_slide()
	

## Handles jump logic
func handle_sonic_jump(delta: float):
	# Handle jump.
	if not sonic_is_on_floor:
		velocity += get_gravity() * delta
		if Input.is_action_pressed("jump"):
			velocity.y -= HELD_JUMP_VELOCITY * delta
	if Input.is_action_just_pressed("jump") and sonic_is_on_floor:
		var normal := get_floor_normal()
		velocity += normal * INITIAL_JUMP_VELOCITY

## Handles left and right movement inputs (very messy lol)
func handle_sonic_left_right_movement(delta: float) -> void:
	# Find sonic's state
	var direction: float = Input.get_axis("left", "right")
	var friction: float = FRICTION if sonic_is_on_floor else AIR_FRICTION
	print("sonic is on floor: ", sonic_is_on_floor)
	print("applied friction: ", friction)
	var target := direction * TOP_SPEED
	var accel := ACCEL
	
	if direction == 0:
		accel = friction
	else:
		if sign(direction) != sign(velocity.x):
			accel += friction
	
	print("accel value: ", accel)
	velocity.x = move_toward(
		velocity.x,
		target,
		accel * delta
	)

func handle_sonic_rotation_to_ground(delta: float) -> void:
	if sonic_is_on_floor:
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
