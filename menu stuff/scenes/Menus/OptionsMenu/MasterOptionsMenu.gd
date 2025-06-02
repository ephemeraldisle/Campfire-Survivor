extends "res://addons/maaacks_menus_template/base/scenes/Menus/OptionsMenu/MasterOptionsMenu.gd"

@onready var texture_rect: TextureRect = $TextureRect

func hide_tex() -> void:
	texture_rect.visible = false
