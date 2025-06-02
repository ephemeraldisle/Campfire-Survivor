extends Node

var campfire
var player
var game_running = false
var terrain_total = 0
var loaded_terrain = 0

var kill_count = 69
var time_count = 500
var heat_count = 8

func reset() -> void:
	kill_count = 0
	time_count = 0
	heat_count = 0


func terrain_loaded() -> void:
	loaded_terrain += 1
	if loaded_terrain == terrain_total:
		GameEvents.terrain_loaded.emit()
