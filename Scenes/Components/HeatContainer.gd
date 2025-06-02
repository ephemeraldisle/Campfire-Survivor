extends MarginContainer
@onready var heat: AnimatedSprite2D = %Heat

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var heat_label: Label = %HeatLabel

func _ready() -> void:
	await get_tree().process_frame
	User.heat_manager.heat_progress_changed.connect(_on_heat_progress_changed)
	User.heat_manager.heat_level_changed.connect(_on_heat_level_changed)

func enable_hud():
	heat.visible = true
	animation_player.play("appear")

func update_display_value(level: int) -> void:
	heat_label.text = "%s   " % level

func disable_hud(instant = false):
	animation_player.play_backwards("appear")
	if not instant:
		await animation_player.animation_finished
	heat.visible = false

func _on_heat_progress_changed(amount: float) -> void:
	heat.play("collect")
	await heat.animation_finished
	heat.play("idle")

func _on_heat_level_changed(amount: int) -> void:
	update_display_value(amount)
