extends Node2D

@export var trees:Array[PackedScene]

var object_holder

func _ready() -> void:
	object_holder = get_tree().get_first_node_in_group("objectholder")
	
	randomize()
	var tree_to_spawn = trees.pick_random().instantiate()
	await get_tree().process_frame
	tree_to_spawn.global_position = global_position
	object_holder.add_child(tree_to_spawn)
	
