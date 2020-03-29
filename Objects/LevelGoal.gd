extends Area2D

func _ready():
	var anim = get_node("AnimationPlayer").get_animation("idle")
	anim.set_loop(true)
	get_node("AnimationPlayer").play("idle")

func _on_Area2D_body_entered(body):
	if body.is_in_group('ant'):
		MenuHandler.win_screen()
		$AudioStreamPlayer2D.play()
