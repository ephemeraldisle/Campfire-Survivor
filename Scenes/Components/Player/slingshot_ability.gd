extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var root_position = Vector2.ZERO
var base_rotation = Vector2.RIGHT
var speed = 20
var direction
var max_life = 2
var life = 0

func _ready():
	root_position = global_position + Vector2(0, -100)
	base_rotation = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var mouse_pos = get_global_mouse_position()
	direction = GameState.player.global_position.direction_to(mouse_pos)

func _physics_process(delta: float) -> void:
	life += delta
	if life >= max_life:
		queue_free()
	global_position += direction * speed

func _on_break_box_body_entered(body: Node2D) -> void:
	call_deferred("queue_free")
