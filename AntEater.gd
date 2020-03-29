extends Area2D
class_name AntEater

func _ready():
	$Line2D.hide()
	$IdleTimer.start()

func _on_AntEater_body_entered(body) -> void:
	if body.is_in_group('ant'):
		var path = $Navigation2D.get_simple_path(self.position, body.position)
		for i in path:
			var x = -i.x
			var y = i.y
			$Line2D.add_point(Vector2(x,y))
		$Line2D.show()
		$TongueTimer.start()
		$AnimatedSprite.play('eating')
		body.die()


func _on_AnimatedSprite_animation_finished() -> void:
	$AnimatedSprite.stop()


func _on_IdleTimer_timeout() -> void:
	$AnimatedSprite.play('Idle')


func _on_TongueTimer_timeout() -> void:
	$Line2D.hide()