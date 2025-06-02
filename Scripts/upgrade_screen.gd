extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var level_up_sound: AudioStream
@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = $%CardContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	pass

func make_visible():
	show()
	animation_player.play("in")
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += 0.15


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	hide()
