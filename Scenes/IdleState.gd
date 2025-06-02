extends "res://Scripts/state.gd"

@export var velocity_component: Node

@export var body: CharacterBody2D

func enter() -> void:
	pass
	#print("I'm idle")

func _physics_process(delta: float) -> void:
	if active:
		velocity_component.decelerate()
		if not body.stunned:
			Transitioned.emit(self, "ChaseState")
