extends Node2D
#class_name Attack

const CLEANUP_TIME = 3

@export var hit_indicator: PackedScene
@export var hit_effect: PackedScene
@export var hitbox: PackedScene

var damage
var delay_before_damage: float
var indicator
var spawned_hit_effect
var spawned_hitbox

@onready var hit_sound: AudioStreamPlayer2D = %HitSound
@onready var warmup_sound: AudioStreamPlayer2D = %WarmupSound

func register_properties(dmg: int, delay: float) -> void:
	damage = dmg
	delay_before_damage = delay

func attack_process() -> void:
	spawn_hit_indicator()
	play_warmup_sound()
	await get_tree().create_timer(delay_before_damage).timeout
	spawn_hitbox()
	play_hit_effect()
	play_hit_sound()
	await get_tree().create_timer(CLEANUP_TIME).timeout
	queue_free()

func spawn_hit_indicator() -> void:
	indicator = hit_indicator.instantiate()
	add_child(indicator)
	indicator.global_position = global_position

func play_warmup_sound() -> void:
	warmup_sound.play()

func play_hit_effect() -> void:
	spawned_hit_effect = hit_effect.instantiate()
	add_child(spawned_hit_effect)
	spawned_hit_effect.global_position = global_position

func play_hit_sound() -> void:
	hit_sound.play()
	
func spawn_hitbox() -> void:
	spawned_hitbox = hitbox.instantiate()
	add_child(spawned_hitbox)
	spawned_hitbox.global_position = global_position
	spawned_hitbox.register_damage(damage)
