extends Control

func _ready():
	$VBoxContainer/Next.visible = true
	$VBoxContainer/Back.visible = false
	MenuHandler.hide_GUI()

func _on_Back_pressed():
	MenuHandler.end_game()


func _on_StartGame_pressed():
	MenuHandler.start_game()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Next_pressed():
	$Cutscene/AnimationPlayer.play('fall')
	$VBoxContainer/Next.visible = false
	$VBoxContainer/Back.visible = true
	
