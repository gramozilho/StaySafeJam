extends Node

func _unhandled_key_input(event : InputEventKey) -> void:
	if (Input.is_action_just_pressed("quit_game")):
		get_tree().quit()
	elif (Input.is_action_just_pressed("reload_scene")):
		get_tree().reload_current_scene()
	pass
