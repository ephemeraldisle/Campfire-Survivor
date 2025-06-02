extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_increased

@export var max_health: int = 10
@onready var current_health = max_health
@export var is_player = false
@export var visuals: AnimatedSprite2D

func damage(damage_amount: int):
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit()
	#print(current_health)
	if is_player:
		GameEvents.emit_health_changed(current_health)
	else:
		Callable(check_death).call_deferred()

func heal(heal_amount: int):
	print("HEAL ME PLEASE")
	current_health = min(current_health+heal_amount, max_health)
	health_increased.emit()
	GameEvents.emit_health_changed(current_health)

func get_health_percent():
		if max_health <= 0: return 0
		return min(current_health/max_health, 1)
	
	
func check_death():
	if current_health == 0:
		await visuals.animation_finished
		died.emit()
		GameState.kill_count += 1
		owner.queue_free()
