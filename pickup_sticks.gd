extends Node2D
@onready var stick: AnimatedSprite2D = %Stick

@export var resource_amount: int = 1
@export var stick_sound: AudioStream

var is_collected = false
var collector
var tween

signal collected

func _ready() -> void:
	stick.play("stick%d" %randi_range(1,4))
	stick.rotation_degrees += randi_range(-360, 360)
	var scale_adjust = randf_range(-0.05, 0.05)
	stick.scale += Vector2(scale_adjust, scale_adjust)
	$Area2D.body_entered.connect(_on_body_entered)

func tween_collect(percent: float, start_position: Vector2):
	if collector == null:
		collected.emit()
		queue_free()
		return
	global_position = start_position.lerp(collector.global_position, percent)
	var direction_from_start = collector.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1-exp(-2*get_process_delta_time()))

func collect():
	GameEvents.emit_wood_collected(resource_amount)
	#GameEvents.emit_heat_progress_altered(resource_amount)
	#AudioManager.play_generic(water_sound, global_position, 15)
	collected.emit()
	queue_free()


func _on_body_entered(other: PhysicsBody2D):
	if is_collected or User.wood_on_hand == User.max_wood: return
	is_collected = true	
	User.register_pickup(self)
	collector = other
	tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(stick, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)



