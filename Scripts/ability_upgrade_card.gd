extends PanelContainer

@export var swooshes: AudioStream
@export var clicks: AudioStream

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var pin_icon: TextureRect = %PinIcon

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exit)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	pin_icon.texture = upgrade.icon

func play_in(delay: float=0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")

func select_card():	
	$HoverAnimationPlayer.play("RESET")
	disabled = true
	$AnimationPlayer.speed_scale = 1.15
	$AnimationPlayer.play("selected") 	
	#AudioManager.play_generic(clicks)
	await get_tree().create_timer(0.1).timeout 
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self: continue
		other_card.play_discard()
	await $AnimationPlayer.animation_finished
	selected.emit()
	
	
func play_discard():
	disabled = true
	$AnimationPlayer.play("discard")

func on_mouse_entered():	
	if disabled: return
	$HoverAnimationPlayer.play("hover")
	#AudioManager.play_generic(swooshes)

func on_mouse_exit():	
	if disabled: return
	$HoverAnimationPlayer.play("exit")
	
func on_gui_input(event: InputEvent):
	if disabled: return
	if event.is_action_pressed("click"):
		select_card()
