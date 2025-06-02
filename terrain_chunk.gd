extends Node2D

const tree_placer = preload("res://tree_placer.tscn")
const rock_placer = preload("res://rock_placer.tscn")
const bush_placer = preload("res://Scenes/Environment/bush_placer.tscn")

@onready var rock_test: ShapeCast2D = %RockTest
@onready var bush_test: ShapeCast2D = %BushTest
@onready var tree_test: ShapeCast2D = %TreeTest


const placers = [tree_placer, rock_placer, bush_placer]
@onready var tests = [tree_test, rock_test, bush_test]
var indexes = [0, 1, 2]

var current_index = 0
var directions = []
var steps = []
var spots = []


@export var start_delay: float = 0.5

func _ready() -> void:
	GameState.terrain_total += 1
	start_delay = randfn(start_delay, 0.2)
	#spawn_routine()
	create_direction_array()
	create_step_array()
	create_spot_arry()
	await get_tree().create_timer(start_delay).timeout
	await spawn_routine()
	GameState.terrain_loaded()

func spawn_routine() -> void:
	var starting_position = Vector2.ZERO
	var current_position = starting_position
	var desired_spawn_count = randi_range(15,30)
	var successful_spawns = 0
	var permitted_attempts = 3
	var total_attempts = 0
	var spotted = false
	
	spots.shuffle()
	for spot in spots:
		if spot == global_position:
			if not spotted:
				spotted = true
			else:
				continue
		randomize()
		current_position = spot + Vector2.RIGHT.rotated(randf_range(0, TAU))*250
		
		for i in permitted_attempts:
			total_attempts += 1
			if await check_point(current_position):
				var placer = placers[current_index].instantiate()
				add_child(placer)
				placer.global_position = current_position
				successful_spawns += 1
				if successful_spawns >= desired_spawn_count:
					return
				else:
					break
			else:
				var adjust_vector = Vector2.RIGHT.rotated(randf_range(0, TAU))
				current_position += adjust_vector * 300


func create_direction_array():
	var min_angles = 60
	for i in 6:
		directions.append(0+(i*min_angles))
	directions.shuffle()
	#print(directions)
	
func create_step_array():
	for i in 4:
		steps.append((i+1)*250)
	steps.shuffle()
	#print(steps)

func create_spot_arry():
	for direction in directions.size():
		var direction_vector = Vector2.RIGHT.rotated(randf_range(0, TAU)).rotated(deg_to_rad(direction))
		for step in steps:
			var spot = global_position + (direction_vector*step)
			spots.append(spot)
	randomize()
	spots.shuffle()
	#print(spots)

func test_valid(spot: Vector2) -> bool:
	#print("testing")
	#print(current_index)
	var test = tests[current_index]
	test.global_position = spot
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	#print(test.is_colliding())
	return !test.is_colliding()

func check_point(spot: Vector2) -> bool:
	#print(spot)
	indexes.shuffle()
	var could_place = false
	var this_index = 0
	while could_place == false and this_index <3:
		current_index = indexes[this_index]
		if await test_valid(spot):
			return true
		this_index +=1
	return false
