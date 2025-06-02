extends Node2D

@onready var heart_container: MarginContainer = %HeartContainer
@onready var heat_container: MarginContainer = %HeatContainer
@onready var wood_container: MarginContainer = %WoodContainer
@onready var campfire_container: MarginContainer = %CampfireContainer
@onready var heat_manager: Node = %HeatManager
@onready var heat_bar: TextureProgressBar = %HeatBar
@onready var ui: CanvasLayer = $UI
@onready var death_screen_animator: AnimationPlayer = $DeathScreenAnimator
@onready var death: CanvasLayer = $Death
@onready var time_manager: Node = $TimeManager
@onready var end_screen: CanvasLayer = $EndScreen
@onready var upgrade_screen: CanvasLayer = %UpgradeScreen

@export var pause_menu_scene: PackedScene

var pickups_in_transit = []
var wood_on_hand = 0
var max_wood = 10
var campfire_health = 100

signal wood_changed
signal wood_burned
signal campfire_hurt
signal campfire_heal
signal campfire_drain

func _ready() -> void:
	GameEvents.wood_collected.connect(_on_wood_changed)
	GameEvents.won.connect(game_end)

func start_time() -> void:
	time_manager.start_tracking()
	
func reset_time() -> void:
	time_manager.reset()


func _on_wood_changed(amount: int) -> void:
	wood_on_hand = clamp(wood_on_hand + amount, 0, max_wood)
	if amount == -1:
		GameEvents.emit_heat_progress_altered(1)
		change_campfire_health(20)
	wood_changed.emit(wood_on_hand)

func change_campfire_health(amount) -> void:
	campfire_health = clamp(campfire_health+amount, 0, 100)
	if amount > 0:
		campfire_heal.emit(campfire_health)
	else:
		campfire_hurt.emit(campfire_health)
		if campfire_health <= 0:
			GameState.player.on_damage(99999)

func drain_campfire(amount) -> void:
	campfire_health = max(campfire_health-amount, 0)
	campfire_drain.emit(campfire_health)

func enable_ui() -> void:
	ui.visible = true
	heart_container.enable_hud()
	heat_container.enable_hud()
	wood_container.enable_hud()
	heat_bar.visible = true
	campfire_container.enable_hud()
	
func disable_ui(instant = false) -> void:
	ui.visible = false
	heart_container.disable_hud(instant)
	heat_container.disable_hud(instant)
	heat_bar.visible = false
	wood_container.disable_hud(instant)
	campfire_container.disable_hud(instant)

func register_pickup(pickup: Node):
	pickups_in_transit.append(pickup)

func clean_up_pickups() -> void:
	for pickup in pickups_in_transit:
		if pickup != null:
			pickup.tween.kill()
			pickup.queue_free()

func _unhandled_input(event) -> void:
	#if event.is_action_pressed("interact"):
		#player_died()
	
	if GameState.game_running:
		if event.is_action_pressed("pause"):
			get_tree().root.set_input_as_handled()
			var pause = pause_menu_scene.instantiate()
			print("I'm doing a thing")
			disable_ui(true)
			add_child(pause)
			

func player_died() -> void:
	GameEvents.lose()
	game_end()
	#death.visible = true
	#await get_tree().create_timer(0.5).timeout
	#death_screen_animator.play("fade_in", 0.25)
	#await get_tree().create_timer(1).timeout
	#death_screen_animator.play("RESET")
	#death.visible = false

func game_end() -> void:
	disable_ui()
	GameState.game_running = false
	get_tree().paused = true
	end_screen.visible = true


func return_to_main() -> void:
	
	end_screen.visible = false
	get_tree().paused = false
	Callable(SceneLoader.load_scene.bind("res://menu stuff/scenes/Menus/MainMenu/MainMenuWithAnimations.tscn")).call_deferred()
	GlobalCamera.enabled = false 
