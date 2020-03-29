extends KinematicBody2D
class_name Ant

const GRAVITY := 6000.0
const MOVE_SPEED := 25000.0
const JUMP_HEIGHT := -80000
const ACCELERATION : = .5

var _speed := MOVE_SPEED

onready var _floor_cast := $FloorCast
onready var _jump_before_land_timer := $JumpBeforeLandTimer
onready var _jump_after_fallen_timer := $JumpAfterFallenTimer
onready var _wall_cast := $WallCast
onready var _animated_sprite := $AnimatedSprite

var _direction := 0
var _velocity := Vector2()

var _is_floorcast_touching := false
var _is_falling := false

var _has_just_fallen := false
var _has_jumped := false

var is_dead := false

enum MOVEMENT_STATES {
	NORMAL,
	FROZEN,
}

var state = MOVEMENT_STATES.NORMAL

func _ready() -> void:
	pass

func die() -> void:
	if (!is_dead):
		$"Death Sound".play()
		BackgroundMusic.stream_paused = true
	is_dead = true
	pass

func _physics_process(delta : float) -> void:
	match (state):
		MOVEMENT_STATES.NORMAL:
			if (Input.is_action_just_pressed("freeze_ant") && _is_floorcast_touching):  # && AntManager.amount_of_ants < AntManager.max_ants):
				state = MOVEMENT_STATES.FROZEN
				$AnimatedSprite.modulate = Color(1.0, 1.0, 4.0)
				
				var camera : Camera2D = get_node("Camera2D")
				if (is_instance_valid(camera)):
					remove_child(camera)
				
				AntManager.add_ant(self, camera, Vector2(512, 512))
			
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
					$AnimationPlayer.play("Jump")
			move_and_slide_with_snap(_velocity * delta, -_floor_cast.get_collision_normal(), _floor_cast.get_collision_normal(), true)
		MOVEMENT_STATES.FROZEN:
			_animated_sprite.stop()
			_animated_sprite.animation = "Walk"
			_animated_sprite.frame = 0
			pass
	pass

func _movement(delta : float) -> void:
	randomize()
	
	var previous_direction := _direction
	_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if (_direction != 0):
		if (!$"Walk Sound".playing):
			$"Walk Sound".pitch_scale = rand_range(.8, 1.2)
			$"Walk Sound".play()
	else:
		$"Walk Sound".stop()
	
	_velocity.x = lerp(_velocity.x, _direction * MOVE_SPEED, ACCELERATION)
	
	if (Input.is_action_just_pressed("move_dash") && _direction != 0 && _is_floorcast_touching):
		_velocity.x += (_direction * MOVE_SPEED * 10)
	
	if (_wall_cast.is_colliding() && _direction != 0):
		var collider = _wall_cast.get_collider()
		if (collider.is_class("KinematicBody2D")):
			position.y -= 8
	
	if (previous_direction != _direction && previous_direction != 0):
		_animated_sprite.play("Slide")
	
	if (_direction < 0):
		_animated_sprite.flip_h = true
		$CollisionPolygon2D.scale.x = -1
		_wall_cast.scale.x = -1
		if (_animated_sprite.animation != "Slide"):
			_animated_sprite.play("Walk")
	elif (_direction > 0):
		_animated_sprite.flip_h = false
		$CollisionPolygon2D.scale.x = 1
		_wall_cast.scale.x = 1
		if (_animated_sprite.animation != "Slide"):
			_animated_sprite.play("Walk")
	else:
		if (_animated_sprite.animation != "Slide"):
			_animated_sprite.stop()
			_animated_sprite.animation = "Walk"
			_animated_sprite.frame = 0
	
	if (_floor_cast.is_colliding()):
		if (_floor_cast.get_collider().is_in_group("Walkable")):
			_is_floorcast_touching = true
	elif (is_on_floor()):
		_is_floorcast_touching = true
	else:
		_is_floorcast_touching = false
	
	if (!is_on_floor()):
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
		$AnimationPlayer.play("Jump")
	elif (Input.is_action_just_pressed("move_jump")):
		_jump_before_land_timer.start()
	
	if (Input.is_action_just_released("move_jump") && _velocity.y < 0):
		_velocity.y *= .5
	pass

func _on_AnimatedSprite_animation_finished() -> void:
	_animated_sprite.animation = "Walk"
	pass

func _on_Death_Sound_finished():
	var camera : Camera2D = get_node("Camera2D")
	if (is_instance_valid(camera)):
		remove_child(camera)
	
	AntManager.add_ant(self, camera, Vector2(512, 512))
	call_deferred("free")
	BackgroundMusic.stream_paused = false
	pass
