extends Camera2D

#IF TIME PERMITS, LERP TO OFFSET

signal finish_transition

const DEBUG = false
const TRANSITION_TIME = 2.0
const LERP_WEIGHT = 0.15
const PLAYER_VELOCITY_OFFSET = 0.7
const DEFAULT_ZOOM_TIME = 16
const SHAKE = 0.5
const DECAY = 0.8
const MAX_OFFSET = Vector2(160, 90)
const MAX_ROLL = 0.15
const TRAUMA_POWER = 2
const NOISE_FREQUENCY = 0.25
const ARBITRARY_NOISE_OFFSET = 9999
const DEBUG_MOVE_MULTIPLIER = 1500


var aim_node: Node2D
var trauma := 0.0
var base_rotation := 0.0
var noise_y := 0.0
var zoom_tween: Tween
var player: Node2D
var targeting_player = false
var player_velocity = Vector2.ZERO
var stored_velocity = Vector2.ZERO

@onready var center: Vector2 = (
	Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	/ 2
)
@onready var aim_position = Vector2.ZERO
@onready var noise = FastNoiseLite.new()
@onready var base_zoom = zoom
@onready var original_position = global_position


func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = NOISE_FREQUENCY
	position = center
	process_priority = 10
	GameEvents.get_player_velocity.connect(_on_player_velocity_changed)
	GameEvents.main_menu_loaded.connect(disable)

func enable() -> void:
	enabled = true
	make_current()

func disable():
	enabled = false

func _physics_process(delta: float) -> void:
	if not DEBUG:
		if aim_node != null:
			aim_position= aim_node.global_position + player_velocity * PLAYER_VELOCITY_OFFSET
		global_position = lerp(global_position, aim_position, LERP_WEIGHT)
	if trauma:
		trauma = max(trauma - DECAY * delta, 0)
		shake()
	else:
		rotation = base_rotation
	if DEBUG:
		var direction = Input.get_vector("left", "right", "up", "down")
		global_position += direction * delta * DEBUG_MOVE_MULTIPLIER
		var zoom_axis = Input.get_axis("zoom out", "zoom in")
		var new_zoom = clamp(zoom.x + zoom_axis * delta, 0.05, 5)
		zoom = Vector2(new_zoom, new_zoom)


func follow_node(node: Node2D) -> void:
#	print_debug("following %s" %node)
	aim_node = node
	aim_position = node.global_position


func follow_position(pos: Vector2) -> void:
	aim_node = null
	aim_position = pos


func get_aim_position() -> Vector2:
	var effective_aim_position = aim_position
	if aim_node != null:
		effective_aim_position = aim_node.global_position
	return effective_aim_position


func snap_to_aim() -> void:
	global_position = get_aim_position()


func change_zoom_level(
	new_zoom: Vector2 = base_zoom, transition_time: float = DEFAULT_ZOOM_TIME
) -> void:
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	(
		zoom_tween
		. tween_property(self, "zoom", new_zoom, transition_time)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)


func add_trauma(amount = SHAKE) -> void:
	trauma = amount


func shake() -> void:
#	if not GameState.state.options.screenshake:
#		return
	var amount = pow(trauma, TRAUMA_POWER)

	rotation = base_rotation + MAX_ROLL * amount * noise.get_noise_1d(noise_y)
	offset[0] = MAX_OFFSET[0] * amount * noise.get_noise_1d(noise_y)
	offset[1] = MAX_OFFSET[1] * amount * noise.get_noise_1d(noise_y + ARBITRARY_NOISE_OFFSET)

	noise_y += 1


func get_camera_offset() -> Vector2:
	return global_position - original_position

#func _physics_process(delta):
#	if targeting_player:
#		var player_velocity = player.linear_velocity
#		var speed_component = player_velocity.length() * 0.01
#		if player_velocity.length() <= 0:
#			speed_component = 10
#		target_position = player.global_position+player_velocity*delta*speed_component
#		global_position = global_position.lerp(target_position, 1 - exp(-delta*speed_component))

func _on_player_velocity_changed(velocity) -> void:
	if velocity != Vector2.ZERO:
		player_velocity = lerp(stored_velocity, velocity, LERP_WEIGHT*0.5)
	else:
		player_velocity = velocity
	stored_velocity = player_velocity
