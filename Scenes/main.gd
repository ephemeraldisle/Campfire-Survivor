extends Node2D

func _ready() -> void:
	GameEvents.main_menu_loaded.connect(kill_me)
	GameEvents.phase_complete.connect(phase_end)
	GameState.reset()
	User.reset_time()
	GlobalCamera.enable()
	get_tree().paused = true
	await GameEvents.terrain_loaded
	GameEvents.loaded.emit()
	User.enable_ui()
	get_tree().paused = false
	GameState.game_running = true
	User.start_time()

func kill_me():
	queue_free()

func phase_end(phase):
	if phase == 4:
		GameEvents.win()
