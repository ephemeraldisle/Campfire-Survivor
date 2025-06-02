extends MarginContainer


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var heart: AnimatedSprite2D = %Heart
@onready var ticks: AnimatedSprite2D = %Ticks
@onready var ticks_2: AnimatedSprite2D = %Ticks2

var last_seen_health = 5

func _ready() -> void:
	GameEvents.health_changed.connect(_on_health_changed)

func enable_hud():
	heart.visible = true
	ticks.visible = true
	animation_player.play("appear")
	_on_health_changed(5)

func _on_health_changed(health: int) -> void:
	update_display_value(health)
	if health == last_seen_health:
		return
	if health > last_seen_health:
		#print(health)
		#print(last_seen_health)
		heart.play("heal")
	elif health < last_seen_health:
		heart.play("hurt")
	last_seen_health = health
	await heart.animation_finished
	heart.play("idle")


func update_display_value(health: int) -> void:
	if health == 0:
		ticks.visible = false
	elif health <= 5:
		ticks.visible = true
		var animation_name = "hatch %d" % health
		ticks.play(animation_name)
		ticks_2.visible = false
	elif health <=10:
		ticks.visible = true
		ticks.play("hatch 5")
		var animation_name = "hatch %d" % (health-5)
		ticks_2.visible = true
		ticks_2.play(animation_name)

func disable_hud(instant = false):
	animation_player.play_backwards("appear")
	if not instant:
		await animation_player.animation_finished
	heart.visible = false
	ticks.visible = false
	ticks_2.visible = false
