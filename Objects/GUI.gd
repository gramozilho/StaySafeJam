extends Control

func _process(delta : float) -> void:
	$VBoxContainer/MaximumAntsLabel.text = "Max ants: "+ var2str(AntManager.max_ants)
	$VBoxContainer/AntsLabel.text = "Used ants: "+ var2str(AntManager.amount_of_ants)
	pass
