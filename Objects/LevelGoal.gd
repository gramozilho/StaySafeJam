extends Area2D

var _picked_up := false

func _ready():
	var anim = get_node("AnimationPlayer").get_animation("idle")
	anim.set_loop(true)
	get_node("AnimationPlayer").play("idle")

func _on_Area2D_body_entered(body):
	if body.is_in_group('ant'):
		if (!_picked_up):
			_picked_up = true
			$"Pickup Sound".play()
			visible = false
			MenuHandler.win_screen()
	pass
