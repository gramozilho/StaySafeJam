extends KinematicBody2D
class_name Ant

const GRAVITY := 6000.0
const MOVE_SPEED := 40000.07
const JUMP_HEIGHT := -100000
const ACCELERATION : = .25

var _speed := MOVE_SPEED

onready var _floor_cast := $FloorCast
onready var _wall_cast := $WallCast

var _velocity : Vector2

var _is_floorcast_touching := false

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	_movement(delta)
	move_and_slide(_velocity * delta, _floor_cast.get_collision_normal())
	pass

func _movement(delta : float) -> void:
	var direction := int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	_wall_cast.position.x = direction * 32
	_wall_cast.scale.x = direction
	
	_velocity.x = lerp(_velocity.x, direction * MOVE_SPEED, ACCELERATION)
	
	if (_floor_cast.is_colliding() || is_on_floor()):
		_is_floorcast_touching = true
	else:
		_is_floorcast_touching = false
		_velocity.y += GRAVITY
	
	if (is_on_floor()):
		_velocity.y = 0
	
	if (is_on_ceiling()):
		_velocity.y = GRAVITY
	
	if (Input.is_action_just_pressed("move_jump") && _is_floorcast_touching):
		_velocity.y = JUMP_HEIGHT
	
	if (Input.is_action_just_released("move_jump") && _velocity.y < 0):
		_velocity.y *= .5
	pass
