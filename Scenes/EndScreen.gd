extends Control

func _ready():
	$VBoxContainer/Next.visible = true
	$VBoxContainer/Back.visible = false
	MenuHandler.hide_GUI()

func _on_Back_pressed():
	MenuHandler.end_game()


func _on_Next_pressed():
	$Button.play()
	$Cutscene/AnimationPlayer.play('fall')
	$VBoxContainer/Next.visible = false
	$VBoxContainer/Back.visible = true
	
