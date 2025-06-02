extends Node

var time_between_heals = 30
@onready var health_component = $".."
var regenerating = false
@onready var timer = $Timer

#var floating_text_scene = preload("res://scenes/ui/floating_test.tscn")

func _ready():
	timer.timeout.connect(on_timer_timeout)
	var regeneration_count = SaveManager.get_upgrade_count("health_regeneration")
	regeneration_count += 1
	if regeneration_count > 0:
		health_component.health_changed.connect(on_health_changed)
		health_component.health_increased.connect(on_health_changed)
		time_between_heals = 30 / regeneration_count

func on_health_changed():
	if health_component.current_health > 0 and health_component.current_health < health_component.max_health:
		regenerating = true
		if timer.time_left > 0:
			return
		timer.start(time_between_heals)

func on_timer_timeout():
	health_component.heal(1)
	#var floating_text = floating_text_scene.instantiate() as Node2D
	#get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	#floating_text.global_position = get_parent().get_parent().global_position + Vector2.UP*16
	#floating_text.set_color(Color.html("41e0b3"))
	#floating_text.start("+1")
