extends "res://Scripts/state.gd"

@export var attack_range = 15000
@export var body: CharacterBody2D
@export var velocity_component: Node
var campfire
var player

func _ready() -> void:
	campfire = GameState.campfire
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if active:
		if body.stunned:
			Transitioned.emit(self, "IdleState")
			return
		if not body.has_seen_player:
			var my_position = body.global_position
			var distance = my_position.distance_squared_to(campfire.global_position)
			if distance >= attack_range:
				velocity_component.accelerate_to_campfire()
			else:
				Transitioned.emit(self, "AttackState")
		else:
			var my_position = body.global_position
			var distance = my_position.distance_squared_to(player.global_position)
			if distance >= attack_range:
				velocity_component.accelerate_to_player()
			else:
				Transitioned.emit(self, "AttackState")
		velocity_component.move(body)
