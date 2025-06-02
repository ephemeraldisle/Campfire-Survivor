extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5
@export var friction: float = 300
@export var is_player: bool = false
@export var dash_speed: int = 80

var velocity = Vector2.ZERO
@onready var current_speed = max_speed

func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null: return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
	
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	
	accelerate_in_direction(direction)

func accelerate_to_campfire():
	var owner_node2d = owner as Node2D
	if owner_node2d == null: return
	
	var campfire = GameState.campfire
	if campfire == null: return
	
	var direction = (campfire.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * current_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_physics_process_delta_time()))
	


func decelerate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
	if is_player:
		GameEvents.emit_player_velocity(velocity)


