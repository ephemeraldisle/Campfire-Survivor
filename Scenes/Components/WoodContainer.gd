extends MarginContainer


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wood: AnimatedSprite2D = %Wood
@onready var ticks: AnimatedSprite2D = %Ticks
@onready var ticks_2: AnimatedSprite2D = %Ticks2

var last_seen_wood = 0

func _ready() -> void:
	User.wood_changed.connect(_on_wood_changed)

func enable_hud():
	wood.visible = true
	animation_player.play("appear")
	update_display_value(0)

func _on_wood_changed(amount: int) -> void:
	update_display_value(amount)
	if amount == last_seen_wood:
		return
	if amount > last_seen_wood:
		wood.play("increase")
	if amount < last_seen_wood:
		wood.play("decrease")
	last_seen_wood = amount
	await wood.animation_finished
	wood.play("idle")

func update_display_value(sticks: int) -> void:
	if sticks == 0:
		ticks.visible = false
		ticks_2.visible = false
	elif sticks <= 5:
		var animation_name = "hatch %d" % sticks
		ticks.visible = true
		ticks.play(animation_name)
		ticks_2.visible = false
	elif sticks <=10:
		ticks.visible = true
		ticks.play("hatch 5")
		var animation_name = "hatch %d" % (sticks-5)
		ticks_2.visible = true
		ticks_2.play(animation_name)

func disable_hud(instant = false):
	animation_player.play_backwards("appear")
	if not instant:
		await animation_player.animation_finished
	wood.visible = false
	ticks.visible = false
	ticks_2.visible = false
