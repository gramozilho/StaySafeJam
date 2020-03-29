extends Sprite
class_name Flower

func _ready() -> void:
	randomize()
	$AnimationPlayer.playback_speed = randf() + 0.1
	$AnimationPlayer.play("Sway")
	pass
