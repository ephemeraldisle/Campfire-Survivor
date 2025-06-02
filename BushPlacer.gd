extends Node2D

@export var bushes:Array[PackedScene]

var object_holder

func _ready() -> void:
	object_holder = get_tree().get_first_node_in_group("objectholder")
	
	randomize()
	var bush_to_spawn = bushes.pick_random().instantiate()
	await get_tree().process_frame
	bush_to_spawn.global_position = global_position
	object_holder.add_child(bush_to_spawn)
	
