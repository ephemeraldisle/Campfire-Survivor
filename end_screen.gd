extends CanvasLayer

@onready var result_text: Label = %ResultText
@onready var kill_count: Label = %KillCount
@onready var time_count: Label = %TimeCount
@onready var heat_count: Label = %HeatCount
@onready var medal_count: Label = %MedalCount

@export var upgrade_scene: PackedScene

func _ready() -> void:
	GameEvents.won.connect(update_victory)
	GameEvents.lost.connect(update_loss)

func update_victory():
	result_text.text = "You survived the night!"
	update_numbers()

func update_loss():
	result_text.text = "You failed to survive the night..."
	update_numbers()

func update_numbers():
	var kills = GameState.kill_count
	var time = int(GameState.time_count)
	var heat = GameState.heat_count
	kill_count.text = "...%s" % kills
	time_count.text = "...%s" % time
	heat_count.text = "...%s" % heat
	var medals = kills * 0.2
	medals += time * 0.05
	medals += heat
	medals = int(medals)
	medal_count.text = "+%s" % medals
	GameEvents.award_medals(medals)


func _on_quit_pressed() -> void:
	User.return_to_main()


func _on_upgrades_pressed() -> void:
	var s = upgrade_scene.instantiate()
	add_child(s)


func _on_play_pressed() -> void:
	SceneLoader.load_scene("res://Scenes/main.tscn")
