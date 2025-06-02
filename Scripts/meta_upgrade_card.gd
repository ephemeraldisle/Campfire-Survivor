extends PanelContainer

@export var swooshes: AudioStream
@export var clicks: AudioStream

signal selected

var upgrade: MetaUpgrade

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
#@onready var progress_bar = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ProgressBar
@onready var progress_label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/ProgressLabel
@onready var count_label = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/CountLabel

#@onready var label = $Label

var disabled = false
var purchasable = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exit)

func update_progress():
	var current_count = 0
	if SaveManager.save_data["meta_upgrades"].has(upgrade.id):
		current_count = SaveManager.save_data["meta_upgrades"][upgrade.id]["quantity"]
	
	var is_maxed = current_count == upgrade.max_quantity
	
	var percent = SaveManager.save_data["medals"] / upgrade.experience_cost
	percent = min(percent, 1)
	#progress_bar.value = percent
	purchasable = percent == 1 and !is_maxed
	
	if !is_maxed:
		progress_label.text = str( SaveManager.save_data["medals"]) + "/" + str(upgrade.experience_cost)
		count_label.text = ("%d►" % current_count) + ("%d" % (current_count+1))
	else: 
		progress_label.text = "Maximum Level"
		count_label.text = "%d" % current_count

#func _process(delta):
#	label.text = str(z_index)

func set_meta_upgrade(new_upgrade: MetaUpgrade):
	name_label.text = new_upgrade.name
	description_label.text = new_upgrade.description
	upgrade = new_upgrade
	update_progress()

func play_in(delay: float=0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")

func select_card():	
	if !purchasable or upgrade == null: return
	disabled = true
	$HoverAnimationPlayer.play("RESET")
	$HoverAnimationPlayer.stop()
	SaveManager.add_meta_upgrade(upgrade)
	SaveManager.save_data["medals"] -= upgrade.experience_cost
	SaveManager.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	z_index = 10
	$AnimationPlayer.speed_scale = 1.15
	$AnimationPlayer.play("selected") 	
	#AudioManager.play_generic(clicks)
	await $AnimationPlayer.animation_finished
	disabled = false

func on_mouse_entered():	
	if disabled or !purchasable or upgrade == null: return
	$HoverAnimationPlayer.play("hover")
	#AudioManager.play_generic(swooshes)

func on_mouse_exit():	
	if disabled: return
	$HoverAnimationPlayer.play("exit")
	
func on_gui_input(event: InputEvent):
	if disabled: return
	if event.is_action_pressed("click"):
		select_card()
