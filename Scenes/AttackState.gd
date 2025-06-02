extends "res://Scripts/state.gd"

@export var body: CharacterBody2D
@export var velocity_component: Node
@export var damage: int
@export var warmup_time: float
@export var attack_time: float
@export var cooldown_time: float
@export var attack_range: float
@export var attack: PackedScene

var target
var spawn_holder

var on_cooldown = false

func _ready() -> void:
	spawn_holder = get_tree().get_first_node_in_group("objectholder")

func enter() -> void:
	if on_cooldown:
		#print("SORRY COOLWON")
		await get_tree().create_timer(0.001).timeout
		Transitioned.emit(self, "ChaseState")
		return
	#print("starting attack")
	velocity_component.decelerate()
	
	if body.has_seen_player:
		target = get_tree().get_first_node_in_group("player")
	else:
		target = GameState.campfire
	
	start_attack()

func start_attack() -> void:
	on_cooldown = true
	body.do_an_attack()
	var direction_to_target = body.global_position.direction_to(target.global_position).normalized()
	var indicator_offset = body.global_position + direction_to_target * attack_range
	if body.global_position.distance_squared_to(indicator_offset) > body.global_position.distance_squared_to(target.global_position):
		indicator_offset = target.global_position
	var attacker = attack.instantiate()
	attacker.global_position = indicator_offset
	attacker.register_properties(damage, warmup_time)
	spawn_holder.add_child(attacker)	
	attacker.attack_process()
	await get_tree().create_timer(warmup_time).timeout
	do_attack()

func do_attack() -> void:
	await get_tree().create_timer(attack_time).timeout
	Transitioned.emit(self, "ChaseState")
	await get_tree().create_timer(cooldown_time).timeout
	on_cooldown = false
