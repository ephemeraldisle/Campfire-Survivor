extends Node

@onready var heat_bar: TextureProgressBar = %HeatBar

var current_level = 1
var next_level_cost: float = 5.0
var currently_collected: float = 0.0

signal heat_level_changed
signal heat_progress_changed

func _ready() -> void:
	GameEvents.heat_progress_altered.connect(_on_heat_progress_altered)

func on_heat_level_changed() -> void:
	next_level_cost += 5
	current_level += 1
	heat_level_changed.emit(current_level)
	GameState.heat_count = current_level

func _on_heat_progress_altered(amount: float) -> void:
	#print("hot")
	if currently_collected + amount >= next_level_cost:
		while amount > 0 and currently_collected + amount >= next_level_cost:
			amount = max(amount-next_level_cost, 0)
			currently_collected = amount
			#print(amount)
			on_heat_level_changed()
		return
	currently_collected = clampf(currently_collected + amount, 0, next_level_cost)
	heat_progress_changed.emit(amount)

func _process(delta: float) -> void:
	#print(currently_collected)
	#print(next_level_cost)
	#print(currently_collected / next_level_cost)
	heat_bar.value = (currently_collected / next_level_cost)
	#print(heat_bar.value)
