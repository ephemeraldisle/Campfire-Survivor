extends Control

signal back_pressed

func _unhandled_input(event):
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_page_down"):
		$TabContainer.current_tab = ($TabContainer.current_tab+1) % $TabContainer.get_tab_count()
	elif event.is_action_pressed("ui_page_up"):
		if $TabContainer.current_tab == 0:
			$TabContainer.current_tab = $TabContainer.get_tab_count()-1
		else:
			$TabContainer.current_tab = $TabContainer.current_tab-1

func on_back_button_pressed() -> void:
	back_pressed.emit()
	visible = false
