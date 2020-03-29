extends Area2D
class_name AntEater

func _on_AntEater_body_entered(body : PhysicsBody2D) -> void:
	if (body is Ant):
		var ant = body as Ant
		ant.die()
	pass
