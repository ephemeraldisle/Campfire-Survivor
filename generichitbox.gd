extends Node2D

@onready var area_2d: Area2D = $Area2D
var damage: int

var damaged = false

func register_damage(dmg: int) -> void:
	damage = dmg
	await get_tree().create_timer(0.05).timeout
	damaged = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(body)
	if damaged:
		return
	if body != GameState.player and body != GameState.campfire:
		return
	#print(body.name + " entered!")
	body.on_damage(damage)
	damaged = true
