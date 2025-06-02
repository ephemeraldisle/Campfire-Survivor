extends Area2D

@onready var label: Label = $Label

var active = false

func _on_body_entered(body: Node2D) -> void:
	label.show()
	active = true


func _on_body_exited(body: Node2D) -> void:
	label.hide()
	active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and User.wood_on_hand > 0:
		#print("yay")
		GameEvents.emit_wood_collected(-1)
