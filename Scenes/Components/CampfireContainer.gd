extends MarginContainer

@onready var fire: AnimatedSprite2D = %Fire
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_health_bar: TextureProgressBar = %FireHealthBar

func _ready() -> void:
	User.campfire_heal.connect(heal)
	User.campfire_hurt.connect(hurt)
	User.campfire_drain.connect(drain)

func drain(amount) -> void:
	fire_health_bar.value = amount * 0.01

func heal(amount) -> void:
	fire.play("heal")
	fire_health_bar.value = amount*0.01
	await fire.animation_finished
	fire.play("idle")

func hurt(amount) -> void:
	fire.play("hurt")
	fire_health_bar.value = amount*0.01
	await fire.animation_finished
	fire.play("idle")


func enable_hud():
	fire.visible = true
	animation_player.play("appear")

func disable_hud(instant = false):
	animation_player.play_backwards("appear")
	if not instant:
		await animation_player.animation_finished
	fire.visible = false

