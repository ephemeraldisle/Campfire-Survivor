extends Node

@export var slingshot_ability_scene: PackedScene
@export var base_damage = 5
@export var audio: AudioStream

@export var base_wait_time = 1.5
var isReady = true
var current_wait_time = base_wait_time
var object_holder
var slingshot_count = 1

@onready var damage = base_damage

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	object_holder = get_tree().get_first_node_in_group("objectholder")


func on_timer_timeout():
	var player = GameState.player
	
	for i in slingshot_count:
		var slingshot_instance = slingshot_ability_scene.instantiate() as Node2D
		slingshot_instance.global_position = player.global_position
		object_holder.add_child(slingshot_instance)
		slingshot_instance.hitbox_component.damage = damage	
		await get_tree().create_timer(randfn(0.25,0.05)).timeout
	
	#AudioManager.play_generic(audio, player.global_position)
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "slingshot_damage": 
		damage = base_damage + (current_upgrades["slingshot_damage"]["quantity"])*5
	if upgrade.id == "slingshot_quantity":
		slingshot_count = current_upgrades["slingshot_quantity"]["quantity"]+1
