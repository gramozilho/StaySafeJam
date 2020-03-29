extends CanvasLayer

var menu_on := false setget menu_transition
onready var current_scene
var can_open_menu := true
var current_level := 0

var path_titlescreen := "res://Scenes/TitleMenu.tscn"
var path_lvl1 := "res://Scenes/Level 1.tscn"
var path_lvl2 := "res://Scenes/Level 2.tscn"
var path_endscreen := "res://Scenes/EndScreen.tscn"
var path_levels := [path_lvl1, path_lvl2, path_endscreen]

const MSG_LEVEL_COMPLETED := "Level completed!"
const MSG_LEVEL_FAILED := "Level failed :("

const GAME_MENU_ON_X := 1370
const GAME_MENU_OFF_X := 1950

func _ready() -> void:
	reset_menus()
	update_current_scene()


func update_current_scene():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	print("current_scene: ", current_scene)

	$Transition.get_material().set_shader_param("cutoff", 1.0)
	
func _process(delta : float) -> void:
	# keeping the menu handling here for now to keep my work on separate scenes
	if can_open_menu:
		if Input.is_action_just_pressed("toggle_menu"): # later add check to assure not on title screen
			self.menu_on = !self.menu_on
		if Input.is_action_just_pressed("trigger_win"):
			win_screen()
		if Input.is_action_just_pressed("trigger_lose"):
			lose_screen()
	
	# Update GUI
	$GUI/VBoxContainer/MaximumAntsLabel.text = "Max ants: "+ var2str(AntManager.max_ants)
	$GUI/VBoxContainer/AntsLabel.text = "Used ants: "+ var2str(AntManager.amount_of_ants)
	pass

func menu_transition(turn_on) -> void:
	var current_x = $GameMenu.position.x
	if turn_on:
		$Tween.interpolate_property($GameMenu, "position:x", current_x, GAME_MENU_ON_X, .4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property($GameMenu, "position:x", current_x, GAME_MENU_OFF_X, .3, Tween.TRANS_QUAD, Tween.EASE_IN)
	menu_on = turn_on
	$Tween.start()

func reset_menus() -> void:
	menu_on = false
	$GameMenu.position.x = GAME_MENU_OFF_X
	$EndScreen.visible = false
	if path_levels[current_level] == path_endscreen:
		$GUI.visible = false
		can_open_menu = false
	else:
		$GUI.visible = true
		can_open_menu = true
	

func _on_Restart_pressed() -> void:
	reset_menus()
	goto_scene(path_levels[current_level])
	#goto_scene(path_levels[current_level])


func _on_BackToMenu_pressed() -> void:
	goto_scene(path_titlescreen)
	$GUI.visible = false
	can_open_menu = false


func goto_scene(path) -> void:
	call_deferred("_deferred_goto_scene", path)
	AntManager.amount_of_ants = 1
	reset_menus()
	$GameMenu/VBoxContainer/BaseSign.text = "Level " + String(current_level+1)  #current_scene.name
	if path == path_titlescreen:
		$GUI.visible = false

func _deferred_goto_scene(path) -> void:
	transition_on(true)
	$Timer.start()
	yield($Timer, "timeout")
	current_scene.call_deferred("free")
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	transition_on(false)

func win_screen() -> void:
	end_level_screen(true)
	#self.menu_on = false
	#can_open_menu = false
	#$EndScreen/VBoxContainer/EndMessage.text = MSG_LEVEL_COMPLETED
	#$EndScreen/VBoxContainer/Next.visible = true
	#$EndScreen.visible = true

func lose_screen() -> void:
	end_level_screen(false)
	#self.menu_on = false
	#can_open_menu = false
	#$EndScreen/VBoxContainer/EndMessage.text = MSG_LEVEL_FAILED
	#$EndScreen/VBoxContainer/Next.visible = false
	#$EndScreen.visible = true

func end_level_screen(win) -> void:
	self.menu_on = false
	can_open_menu = false
	if win:
		$EndScreen/VBoxContainer/EndMessage.text = MSG_LEVEL_COMPLETED
	else:
		$EndScreen/VBoxContainer/EndMessage.text = MSG_LEVEL_FAILED
	$EndScreen/VBoxContainer/Next.visible = win
	
	$EndScreen.visible = true

func transition_on(turn_on) -> void:
	if turn_on:
		$TweenTransition.interpolate_property($Transition.get_material(), "shader_param/cutoff", 1.0, 0.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	else:
		$TweenTransition.interpolate_property($Transition.get_material(), "shader_param/cutoff", 0.0, 1.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenTransition.start()

func _on_Next_pressed() -> void:
	#current_level = (current_level + 1) % len(path_levels)
	current_level += 1
	goto_scene(path_levels[current_level])
	if current_level == len(path_levels):
		can_open_menu = false

func start_game() -> void:
	current_level = 0
	goto_scene(path_levels[current_level])

func end_game() -> void:
	current_level = 0
	goto_scene(path_titlescreen)
	
