extends TextureButton

@export var item : Item:
	set(value):
		item = value
		
		texture_normal = value.texture
		$Label.text = "Lvl " + str(item.level + 1)
		$Description.text = value.upgrades[value.level - 1].description
		


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and item:
		print(item.title)
		item.upgrade_item()
		get_parent().close_option()
	if event.is_action_pressed("ui_accept") and item:
		print(item.title)
		item.upgrade_item()
		get_parent().close_option()

func _ready() -> void:
	grab_focus()
