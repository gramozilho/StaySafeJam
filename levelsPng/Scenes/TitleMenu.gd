extends Control

func _ready():
	MenuHandler.hide_GUI()

func _on_Back_pressed():
	MenuHandler.end_game()


func _on_StartGame_pressed():
	MenuHandler.start_game()


func _on_Exit_pressed():
	get_tree().quit()
