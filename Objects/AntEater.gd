extends Area2D
class_name AntEater

func _ready():
	$Line2D.hide()
	$IdleTimer.start()

func _on_AntEater_body_entered(body) -> void:
	if body.is_in_group('ant'):
		var path = [Vector2(0, 8), (body.get_global_position() - self.get_global_position() )]
		print(path)
		for i in path:
			$Line2D.add_point(i)
		$Line2D.show()
		$TongueTimer.start()
		$AnimatedSprite.play('eating')
		body.hide()
		body.die()


func _on_AnimatedSprite_animation_finished() -> void:
	$AnimatedSprite.stop()


func _on_IdleTimer_timeout() -> void:
	$AnimatedSprite.play('Idle')


func _on_TongueTimer_timeout() -> void:
	$Line2D.clear_points()
	$Line2D.hide()
