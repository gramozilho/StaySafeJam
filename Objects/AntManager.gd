extends Node

onready var ant_scene : PackedScene = preload("res://Objects/Ant.tscn")

func _ready() -> void:
	
	pass

func add_ant(camera : Camera2D = null, position := Vector2()) -> void:
	var ant_instance = ant_scene.instance()
	ant_instance.global_position = position
	
	get_tree().current_scene.call_deferred("add_child", ant_instance)
	
	if (camera != null):
		ant_instance.call_deferred("add_child", camera)
	pass
