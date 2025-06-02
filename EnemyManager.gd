extends Node

const SPAWN_RADIUS = 2000

@export var basic_enemy_scene: PackedScene
@export var stretchy_enemy_scene: PackedScene
@export var floaty_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var arena_time_manager: Node
@export var mean_spawn_time: float = 5.0

@onready var timer = $Timer
@onready var default_time = mean_spawn_time

var entities_layer
var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 15)
	timer.timeout.connect(on_timer_timeout)
	entities_layer = get_tree().get_first_node_in_group("objectholder")
	GameEvents.phase_complete.connect(new_phase)
	
func get_spawn_position():
	var player = GameState.player
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var rotation_direction = pow(-1, randi_range(1, 2))
	for i in 4:
		spawn_position = player.global_position + random_direction * SPAWN_RADIUS

		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + random_direction*30, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty(): break
		else: random_direction = random_direction.rotated(deg_to_rad(90*rotation_direction))

	return spawn_position

func on_timer_timeout():
	var player = GameState.player
	
	var enemy_scene = enemy_table.pick_item()
	
	var enemy = enemy_scene.instantiate()
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()
	#enemy.alert_spawn()
	timer.wait_time = max(randfn(mean_spawn_time, 0.1), 0.02)

func new_phase(phase):
	mean_spawn_time = max(default_time - phase*0.02, 0.05)
	
	#if phase == 6:
		#enemy_table.add_item(floaty_enemy_scene, 5)
	#elif phase == 10:
		#enemy_table.add_item(floaty_enemy_scene, 5)
		#enemy_table.add_item(stretchy_enemy_scene, 5)
	#elif phase == 15:
		#enemy_table.add_item(floaty_enemy_scene, 4)
		#enemy_table.add_item(ghost_enemy_scene, 1)
	#elif phase == 20:
		#enemy_table.add_item(basic_enemy_scene, 20)
		#enemy_table.add_item(wizard_enemy_scene, 10)
		#enemy_table.add_item(stretchy_enemy_scene, 5)
	#elif phase == 30:		
		#enemy_table.add_item(wizard_enemy_scene, 20)
	#elif phase == 35:		
		#enemy_table.add_item(ghost_enemy_scene, 20)
	#elif phase == 40:
		#enemy_table.add_item(stretchy_enemy_scene, 15)
