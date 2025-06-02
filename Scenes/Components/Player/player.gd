extends CharacterBody2D


const STANDARD_SCREENSHAKE_NUMBER = 0.5

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Art
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var stamina_bar: ProgressBar = $StaminaBar
@onready var sprint_clouds: GPUParticles2D = %SprintClouds
@onready var abilities: Node = $Abilities

@onready var base_speed = velocity_component.max_speed
var stun_time = 0.4
var stunned = false
var stamina = 1
var dash = true
func _ready() -> void:
	GlobalCamera.follow_node(self)
	GameState.player = self
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func _physics_process(delta):	
	stamina_bar.value = stamina
	if dash:
		stamina_bar.modulate = Color.WHITE
	else:
		stamina_bar.modulate = Color.DARK_RED
	
	if stunned:
		sprint_clouds.emitting = false
		stamina_bar.hide()
		
	if not stunned:
		
		
		if Input.is_action_pressed("dash") and stamina > 0.005 and dash:
			stamina_bar.show()
			sprint_clouds.emitting = true
			velocity_component.current_speed = velocity_component.max_speed*1.5
			stamina -= delta*0.2
			if stamina <= 0.005:
				dash = false
				stamina = 0.005
		#elif stamina < 0:
			#sprint_clouds.emitting = false
			#velocity_component.current_speed = velocity_component.max_speed*0.5
			#stamina += delta*0.3
			#if stamina >= 0:
				#stamina = 1
		else:
			sprint_clouds.emitting = false
			velocity_component.current_speed = velocity_component.max_speed	 
			if stamina < 0.2:
				stamina += delta*0.1
			if stamina < 1:
				stamina *= 1+delta*0.5
			if stamina >= 0.95:
				stamina = 1
				dash = true
				stamina_bar.hide()
		
		var movement_vector = Input.get_vector("left", "right", "up", "down").normalized()
		if movement_vector != Vector2.ZERO:
			sprite.play("walk")
		else:
			sprite.play("idle")
		velocity_component.accelerate_in_direction(movement_vector)
		velocity_component.move(self)
		var move_sign = sign(movement_vector.x)
		if move_sign!=0:
			visuals.scale.x = move_sign
	else:
		velocity_component.decelerate()
	
#	if movement_vector.x != 0 or movement_vector.y != 0:
#		animation_player.play("walk")
#		if not audio_stream_player_2d.playing: audio_stream_player_2d.play()
#	else:
#		animation_player.queue("RESET")
		

func on_damage(amount: int) -> void:
	if stunned:
		return
	if health_component.current_health - amount > 0:
		GlobalCamera.add_trauma(STANDARD_SCREENSHAKE_NUMBER)
		hurt_sound.play()
		sprite.play("hit")
		health_component.damage(amount)
		stunned = true
		await get_tree().create_timer(stun_time).timeout
		stunned = false

	else:
		GlobalCamera.add_trauma(STANDARD_SCREENSHAKE_NUMBER*1.5)
		hurt_sound.play()
		sprite.global_position.y -= 60
		sprite.play("die")
		health_component.damage(amount)
		stunned = true
		User.player_died()

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is AbilityUnlocker:
		abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + 100*current_upgrades["player_speed"]["quantity"]
