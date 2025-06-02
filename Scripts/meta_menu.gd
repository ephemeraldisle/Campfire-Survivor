extends CanvasLayer

signal back_pressed
@export var upgrades: Array[MetaUpgrade] = []
@onready var back_button = $%BackButton
@onready var currency_counter = %CurrencyCounter
@onready var h_box_container = %HBoxContainer

var meta_upgrade_card_scene = preload("res://Scripts/meta_upgrade_card.tscn")

func _ready():
	for child in h_box_container.get_children():
		child.queue_free()
	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		h_box_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)
		meta_upgrade_card_instance.selected.connect(update_currency_counter)
	back_button.pressed.connect(on_back_button_pressed)
	update_currency_counter()

func on_back_button_pressed():
	#ScreenTransition.transition(1.5)
	#await ScreenTransition.transitioned_halfway
	queue_free()

func update_currency_counter():
	currency_counter.text = str(SaveManager.save_data["medals"])
