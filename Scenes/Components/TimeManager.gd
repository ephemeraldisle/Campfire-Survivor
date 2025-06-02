extends Node
@onready var time_progress_bar_1: TextureProgressBar = %TimeProgressBar1
@onready var time_progress_bar_2: TextureProgressBar = %TimeProgressBar2
@onready var time_progress_bar_3: TextureProgressBar = %TimeProgressBar3
@onready var time_progress_bar_4: TextureProgressBar = %TimeProgressBar4

@onready var bars = [time_progress_bar_1, time_progress_bar_2, time_progress_bar_3, time_progress_bar_4]

var time_per_phase = 90
var time_passed = 0

var tracking = false

var current_bar
var current_phase = 0


func reset() -> void:
	time_progress_bar_1.show()
	time_progress_bar_2.hide()
	time_progress_bar_3.hide()
	time_progress_bar_4.hide()
	current_phase = 0
	for bar in bars:
		bar.value = 0

func start_tracking() -> void:
	tracking = true
	current_bar = bars[current_phase]
	

func _physics_process(delta: float) -> void:
	if tracking:
		GameState.time_count += delta
		current_bar.value = time_passed / time_per_phase
		time_passed += delta
		if time_passed >= time_per_phase:
			time_passed = 0
			current_phase += 1
			GameEvents.emit_phase_complete(current_phase)
			if current_phase < 4:
				current_bar.hide()
				current_bar = bars[current_phase]
				current_bar.show()
			else:
				tracking = false
