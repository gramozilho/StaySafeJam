extends Control

var current_slide := 0
onready var slide_list := []
var click_once = true

func _ready():
	slide_list = $Screen.get_children()
	for slide in slide_list.slice(1, slide_list.size(), 1):
		slide.visible = false
	#$Celebration.play()

func _on_Previous_pressed():
	if current_slide > 0:
		slide_list[current_slide].visible = false
		current_slide -= 1
		$Previous.play()

func _on_Next_pressed():
	if current_slide < (slide_list.size()-1):
		current_slide += 1
		slide_list[current_slide].visible = true
		$Next.play()
	elif click_once:
		click_once = false
		MenuHandler.out_of_cutscene()
		$Next.play()
	pass
