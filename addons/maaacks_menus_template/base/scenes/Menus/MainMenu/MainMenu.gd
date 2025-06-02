class_name MainMenu
extends CanvasLayer


@export_file("*.tscn") var game_scene_path : String
@export var options_packed_scene : PackedScene
@export var credits_packed_scene : PackedScene
@export var version_name : String = '0.0.0'
@export var upgrade_scnee: PackedScene
@onready var camera_2d: Camera2D = $Camera2D
var options_scene
var credits_scene
var sub_menu


func load_scene(scene_path : String):
	SceneLoader.load_scene(scene_path)

func play_game():
	SceneLoader.change_scene_to_loading_screen()

func _open_sub_menu(menu : Control):
	sub_menu = menu
	sub_menu.show()
	%BackButton.show()
	%MenuContainer.hide()

func _close_sub_menu():
	if sub_menu == null:
		return
	sub_menu.hide()
	sub_menu = null
	%BackButton.hide()
	%MenuContainer.show()

func _event_is_mouse_button_released(event : InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()

func _event_skips_intro(event : InputEvent):
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _input(event):
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		%MenuButtons.focus_first()

func _setup_for_web():
	if OS.has_feature("web"):
		%ExitButton.hide()

func _setup_version_name():
	AppLog.version_opened(version_name)
	$"%VersionNameLabel".text = "v%s" % version_name

func _setup_play():
	if game_scene_path.is_empty():
		%PlayButton.hide()

func _setup_options():
	if options_packed_scene == null:
		%OptionsButton.hide()
	else:
		options_scene = options_packed_scene.instantiate()
		options_scene.hide()
		%OptionsContainer.call_deferred("add_child", options_scene)


func _setup_credits():
	%CreditsButton.hide()
	

func _ready():
	print("im ready")
	_setup_for_web()
	_setup_version_name()
	_setup_options()
	_setup_credits()
	_setup_play()
	camera_2d.make_current()
	GameEvents.main_menu_loaded.emit()
	GameEvents.loadin.connect(kill_me)
	SceneLoader.load_scene(game_scene_path, true)

func kill_me():
	queue_free()
	
func _on_play_button_pressed():
	play_game()

func _on_options_button_pressed():
	_open_sub_menu(options_scene)

func _on_credits_button_pressed():
	_open_sub_menu(credits_scene)
	credits_scene.reset()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_credits_end_reached():
	if sub_menu == credits_scene:
		_close_sub_menu()

func _on_back_button_pressed():
	_close_sub_menu()

func _on_upgrades_button_pressed() -> void:
	var s =upgrade_scnee.instantiate()
	add_child(s)
