extends CanvasLayer
@onready var back_button: Button = %BackButton

@export var options_scene: PackedScene
@export var tester: Node2D
var options_instance
var is_closing = false
var viewing_options = false

func _ready():
	#print("hi there")
	GameState.game_running = false
	get_tree().paused = true
#	GlobalCamera.add_trauma(0.5)
	$%ResumeButton.pressed.connect(on_play_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		print("pause dpressed")
		if viewing_options:
			if options_instance != null:
				print("viewing optisn or soiemthn")
				options_instance.on_back_button_pressed()
		else:
			print("I should close")
			close()
		get_tree().root.set_input_as_handled()
	

func close():
	print("bye there")
	User.enable_ui()
	GameState.game_running = true
	get_tree().paused = false
	queue_free()


func on_play_pressed():
	close()

func on_options_pressed():
	viewing_options = true
	if options_instance == null:
		options_instance = options_scene.instantiate()
		#options_instance.transform = transform
		add_child(options_instance)
		options_instance.hide_tex()
		options_instance.back_pressed.connect(on_options_closed)
	print("are we not making")
	options_instance.show()
	print("it here")
	back_button.visible = true
	print("or what")
		#options_instance.animation_player.speed_scale = 2

	

func on_quit_pressed():
	get_tree().paused = false
	GameState.game_running = false
	SceneLoader.load_scene("res://menu stuff/scenes/Menus/MainMenu/MainMenuWithAnimations.tscn")
	GlobalCamera.enabled = false 
	visible = false
	GameEvents.main_menu_loaded.emit()
	queue_free()

func on_options_closed():
	viewing_options = false


func _on_back_button_pressed() -> void:
	print("bb hit")
	options_instance.hide()
	back_button.visible = false
