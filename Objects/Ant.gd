extends KinematicBody2D
class_name Ant

const GRAVITY := 6000.0
const MOVE_SPEED := 30000.0
const JUMP_HEIGHT := -100000
const ACCELERATION : = .25

var _speed := MOVE_SPEED

onready var _floor_cast := $FloorCast
onready var _jump_before_land_timer := $JumpBeforeLandTimer
onready var _jump_after_fallen_timer := $JumpAfterFallenTimer
onready var _wall_cast := $WallCast

var _velocity := Vector2()

var _is_floorcast_touching := false
var _is_falling := false

var _has_just_fallen := false
var _has_jumped := false

enum MOVEMENT_STATES {
	NORMAL,
	FROZEN,
}

var state = MOVEMENT_STATES.NORMAL

func _ready() -> void:
	pass

func die() -> void:
	var camera : Camera2D = get_node("Camera2D")
	if (is_instance_valid(camera)):
		remove_child(camera)
	
	AntManager.add_ant(self, camera, Vector2(320, 296))
	call_deferred("free")
	pass

func _physics_process(delta : float) -> void:
	match (state):
		MOVEMENT_STATES.NORMAL:
			if (Input.is_action_just_pressed("freeze_ant") && _is_floorcast_touching):
				state = MOVEMENT_STATES.FROZEN
				$Sprite.modulate = Color.red
				
				var camera : Camera2D = get_node("Camera2D")
				if (is_instance_valid(camera)):
					remove_child(camera)
				
				AntManager.add_ant(self, camera, Vector2(320, 296))
			_movement(delta)
			
			if (!_is_floorcast_touching):
				if (!_is_falling && !_has_jumped):
					_has_just_fallen = true
					_jump_after_fallen_timer.start()
				_is_falling = true
				_has_just_fallen = false
			else:
				_is_falling = false
				_has_jumped = false
				if (_jump_before_land_timer.time_left > 0.0):
					_velocity.y = JUMP_HEIGHT
					_has_jumped = true
			
			move_and_slide(_velocity * delta, Vector2.UP)
		MOVEMENT_STATES.FROZEN:
			pass
		MOVEMENT_STATES.DEAD:
			pass
	pass

func _movement(delta : float) -> void:
	var direction := int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	_velocity.x = lerp(_velocity.x, direction * MOVE_SPEED, ACCELERATION)
	
	if (direction < 0):
		$Sprite.flip_h = true
	elif (direction > 0):
		$Sprite.flip_h = false
	
	if (_floor_cast.is_colliding() || is_on_floor()):
		_is_floorcast_touching = true
	else:
		_is_floorcast_touching = false
		_velocity.y += GRAVITY
	
	if (is_on_floor()):
		_velocity.y = 0
	
	if (is_on_ceiling()):
		_velocity.y = GRAVITY
	
	if (global_position.y > OS.window_size.y):
		die()
	
	if (Input.is_action_just_pressed("move_jump") && !_has_jumped && (_is_floorcast_touching || _jump_after_fallen_timer.time_left > 0.0)):
		_velocity.y = JUMP_HEIGHT
		_has_jumped = true
	elif (Input.is_action_just_pressed("move_jump")):
		_jump_before_land_timer.start()
	
	if (Input.is_action_just_released("move_jump") && _velocity.y < 0):
		_velocity.y *= .5
	pass
