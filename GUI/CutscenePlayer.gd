extends Control

var current_slide := 0
onready var slide_list := []

func _ready():
	slide_list = $Screen.get_children()
	for slide in slide_list.slice(1, slide_list.size(), 1):
		slide.visible = false

func _on_Previous_pressed():
	if current_slide > 0:
		slide_list[current_slide].visible = false
		current_slide -= 1

func _on_Next_pressed():
	if current_slide < (slide_list.size()-1):
		current_slide += 1
		slide_list[current_slide].visible = true
	else:
		MenuHandler.out_of_cutscene()
