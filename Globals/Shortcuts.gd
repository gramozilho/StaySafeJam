extends Node

func _unhandled_key_input(event : InputEventKey) -> void:
	if (event.is_action_pressed("quit_game")):
		get_tree().quit()
	elif (event.is_action_pressed("reload_scene")):
		AntManager.amount_of_ants = 0
		get_tree().reload_current_scene()
	pass
