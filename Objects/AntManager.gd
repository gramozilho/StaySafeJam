extends Node

onready var ant_scene : PackedScene = preload("res://Objects/Ant.tscn")

var max_ants := 6

var amount_of_ants := 0

func _ready() -> void:
	var starting_ant = get_tree().current_scene.find_node("Ant")
	if (starting_ant != null):
		amount_of_ants += 1
	pass

func add_ant(sender = null, camera : Camera2D = null, position := Vector2()) -> void:
	if (amount_of_ants < max_ants):
		amount_of_ants += 1
		var ant_instance = ant_scene.instance()
		ant_instance.global_position = position
		
		MenuHandler.current_scene.call_deferred("add_child", ant_instance)
		
		if (camera != null):
			ant_instance.call_deferred("add_child", camera)
			var sender_node = sender as Node2D
	elif (amount_of_ants == max_ants):
		MenuHandler.lose_screen()
	pass
