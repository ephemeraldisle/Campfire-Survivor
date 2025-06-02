extends CharacterBody2D

@onready var velocity_component: Node = $VelocityComponent
@onready var art: Node2D = $Art
@onready var player_sensor: Area2D = $PlayerSensor
@onready var enemy_animator: AnimationPlayer = %EnemyAnimator
@onready var visuals: AnimatedSprite2D = %Visuals
@onready var health_component: HealthComponent = $HealthComponent
@onready var shadow: Sprite2D = %Shadow

var has_seen_player = false
var stunned = false

func _ready() -> void:
	stunned = true
	player_sensor.body_entered.connect(_on_sensor_entered)
	health_component.health_changed.connect(_was_hit)
	await get_tree().create_timer(0.2)
	stunned = false

func _physics_process(delta: float) -> void:
	var move_sign = sign(velocity.x)
	if move_sign!=0:
		art.scale.x = move_sign

func _on_sensor_entered(trash):
	has_seen_player = true

func do_an_attack():
	visuals.play("attack")
	enemy_animator.play("attack")
	await visuals.animation_finished
	enemy_animator.play("RESET")
	visuals.play("idle")

func _was_hit() -> void:
	if health_component.current_health > 0:
		visuals.play("hit")
		stunned = true
		await visuals.animation_finished
		stunned = false
		visuals.play("idle")
	else:
		stunned = true
		visuals.play("die")
		shadow.hide()
