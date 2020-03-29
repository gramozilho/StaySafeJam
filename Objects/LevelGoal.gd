extends Area2D

var _picked_up := false

func _on_Area2D_body_entered(body):
	if body.is_in_group('ant'):
		if (!_picked_up):
			_picked_up = true
			$"Pickup Sound".play()
			MenuHandler.win_screen()
	pass
