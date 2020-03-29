extends Sprite
class_name Flower

func _ready() -> void:
	randomize()
	$AnimationPlayer.playback_speed = randf()
	$AnimationPlayer.play("Sway")
	pass
