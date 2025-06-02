extends Node

@export var experience_manager: Node
#var upgrade_screen_scene = preload("res://Scripts/upgrade_screen.tscn")

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

#var upgrade_axe = preload("res://resources/upgrades/axe.tres")
#var upgrade_axe_amount = preload("res://resources/upgrades/axe_quantity.tres")
#var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
#var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
#var upgrade_hammer_damage = preload("res://resources/upgrades/hammer_damage.tres")
#var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
#var upgrade_hammer = preload("res://resources/upgrades/hammer.tres")
#var upgrade_hammer_amount = preload("res://resources/upgrades/hammer_quantity.tres")
var upgrade_player_speed = preload("res://upgrades/player_speed.tres")
var upgrade_slingshot = preload("res://upgrades/slingshot.tres")
var upgrade_slingshot_amount = preload("res://upgrades/slingshot_quantity.tres")
var upgrade_slingshot_damage = preload("res://upgrades/slingshot_damage.tres")
var debug_upgrade = preload("res://upgrades/debuggy.tres")

func _ready():
	#upgrade_pool.add_item(upgrade_axe, 10)
	#upgrade_pool.add_item(upgrade_hammer, 1000000)	
	#upgrade_pool.add_item(upgrade_anvil, 10)
	#upgrade_pool.add_item(upgrade_sword_damage, 10)
	#upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_player_speed, 10)
	upgrade_pool.add_item(upgrade_slingshot, 10)
	upgrade_pool.add_item(debug_upgrade, 10)
	
	User.heat_manager.heat_level_changed.connect(on_level_up)
	

func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_slingshot.id:
		upgrade_pool.add_item(upgrade_slingshot_damage, 10)		
		upgrade_pool.add_item(upgrade_slingshot_amount, 10)
	#if chosen_upgrade.id == upgrade_hammer.id:
		#upgrade_pool.add_item(upgrade_hammer_damage, 10)		
		#upgrade_pool.add_item(upgrade_hammer_amount, 10)
	#if chosen_upgrade.id == upgrade_anvil.id:
		#upgrade_pool.add_item(upgrade_anvil_damage, 10)
		#upgrade_pool.add_item(upgrade_anvil_amount, 10)

func apply_upgrade(upgrade: AbilityUpgrade):	
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)

func on_level_up(current_level: int):
	#var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	#add_child(upgrade_screen_instance)
	var upgrade_screen_instance = User.upgrade_screen
	upgrade_screen_instance.make_visible()
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	
