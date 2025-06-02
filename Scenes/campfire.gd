extends StaticBody2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var direction = "forward"

func _init() -> void:
	GameState.campfire = self


func _on_sprite_2d_animation_finished() -> void:
	if direction == "forward":
		sprite_2d.play_backwards("fire")
		direction = "no"
	else:
		sprite_2d.play("fire")
		direction = "forward"

func on_damage(amount) -> void:
	User.change_campfire_health(-amount*5)

func _physics_process(delta: float) -> void:
	User.drain_campfire(delta)
