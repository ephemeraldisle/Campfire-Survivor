extends Node2D

@export var rocks:Array[PackedScene]

var object_holder

func _ready() -> void:
	object_holder = get_tree().get_first_node_in_group("objectholder")
	randomize()
	var rock_to_spawn = rocks.pick_random().instantiate()

	await get_tree().process_frame
	rock_to_spawn.global_position = global_position
	object_holder.add_child(rock_to_spawn)
	
