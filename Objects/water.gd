extends Area2D

func _on_Water_body_entered(body: Node) -> void:
	if body.is_in_group('ant'):
		body.hide()
		body.die()
