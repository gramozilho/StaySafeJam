extends Button

var _is_hovering := false

func _on_BaseButton_mouse_entered() -> void:
	_is_hovering = true
	modulate = Color(1.5, 1.5, 1.5, 1)
	$AnimationPlayer.play("Bob")
	$HoverSound.play()
	pass

func _on_BaseButton_mouse_exited() -> void:
	_is_hovering = false
	modulate = Color(1, 1, 1, 1)
	$AnimationPlayer.stop()
	rect_scale = Vector2.ONE
	pass

func _on_BaseButton_pressed() -> void:
	$AnimationPlayer.play("Press")
	pass

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	if (_is_hovering):
		$AnimationPlayer.play("Bob")
	pass
