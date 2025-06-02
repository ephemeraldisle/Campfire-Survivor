extends Node

signal water_collected(number: float)
signal ability_access_changed(ability: String)
signal player_damaged

signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

signal full_heal

signal health_changed
signal dialogue_started
signal dialogue_ended
signal unsaved_reset

signal get_player_velocity

signal wood_collected
signal heat_progress_altered

signal loaded
signal main_menu_loaded
signal loadin
signal terrain_loaded
signal phase_complete
signal medals
signal won
signal lost

func win():
	won.emit()

func lose():
	lost.emit()

func award_medals(meds: int) -> void:
	medals.emit(meds)

func emit_phase_complete(new_phase: int) -> void:
	phase_complete.emit(new_phase)

func emit_wood_collected(amount: int) -> void:
	wood_collected.emit(amount)

func emit_heat_progress_altered(amount: float) -> void:
	heat_progress_altered.emit(amount)

func emit_player_velocity(velocity: Vector2) -> void:
	get_player_velocity.emit(velocity)


func emit_dialogue_started() -> void:
	dialogue_started.emit()
	
func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_dialogue_ended() -> void:
	dialogue_ended.emit()


func emit_health_changed(number: int) -> void:
	print("time to change health")
	health_changed.emit(number)




func emit_water_collected(number: float) -> void:
	water_collected.emit(number)


func emit_ability_access_changed(ability: String) -> void:
	ability_access_changed.emit(ability)


func emit_player_damaged() -> void:
	player_damaged.emit()




func emit_full_heal() -> void:
	full_heal.emit()

func emit_unsaved_reset() -> void:
	unsaved_reset.emit()
