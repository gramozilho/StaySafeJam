extends Control

var level_select_on = false
const LEVEL_SELECT_ON = 1500
const LEVEL_SELECT_OFF = 1920

func _ready():
	MenuHandler.hide_GUI()
	$LevelSelect.position.x = LEVEL_SELECT_OFF

func _on_Back_pressed():
	MenuHandler.end_game()


func _on_StartGame_pressed():
	MenuHandler.start_game()


func _on_Exit_pressed():
	get_tree().quit()

func _on_Lvl1_pressed():
	MenuHandler.go_to_lvl(1)

func _on_Lvl2_pressed():
	MenuHandler.go_to_lvl(2)

func _on_Lvl3_pressed():
	MenuHandler.go_to_lvl(3)


func _on_Level_Select_pressed():
	self.level_select_on = !level_select_on
	var current_x = $LevelSelect.position.x
	if level_select_on:
		$Tween.interpolate_property($LevelSelect, "position:x", current_x, LEVEL_SELECT_ON, .4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property($LevelSelect, "position:x", current_x, LEVEL_SELECT_OFF, .3, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
