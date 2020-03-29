extends Button

func _on_BaseButton_mouse_entered():
	modulate = Color(1.5, 1.5, 1.5, 1)
	pass

func _on_BaseButton_mouse_exited():
	modulate = Color(1, 1, 1, 1)
	pass
