extends VBoxContainer

@export var weapons : HBoxContainer
@export var passive_items : HBoxContainer
var OptionSlot = preload("res://Scenes/option_slot.tscn")

@export var particles : GPUParticles2D
@export var panel : NinePatchRect

func _ready() -> void:
	hide()
	particles.hide()
	panel.hide()
	
func close_option():
	hide()
	particles.hide()
	panel.hide()
	get_tree().paused = false

func get_available_resource_in(items) -> Array[Item]:
	var resource : Array[Item] = []
	for item in items.get_children():
		if item.item != null:
			resource.append(item.item)
	return resource

func add_option(item) -> int:
	if item.is_upgradable():
		var option_slot = OptionSlot.instantiate()
		option_slot.item = item
		add_child(option_slot)
		return 1
	return 0
	

#func get_available_weapons():
	#var weapon_resource = []
	#for weapon in weapons.get_children():
		#if weapon.weapon != null:
			#weapon_resource.append(weapon.weapon)
		#return weapon_resource

func show_option():
	var weapons_available = get_available_resource_in(weapons)
	var passive_item_available = get_available_resource_in(passive_items)
	if weapons_available.size() == 0 and passive_item_available.size() == 0:
		return
	
	for slot in get_children():
		slot.queue_free()
	
	var option_size = 0
	for weapon in weapons_available:
		option_size += add_option(weapon)
		
		if weapon.max_level_reached() and weapon.item_needed in passive_item_available:
			var option_slot = OptionSlot.instantiate()
			option_slot.item = weapon
			add_child(option_slot)
			option_size += 1
	
	for passive_item in passive_item_available:
		option_size += add_option(passive_item)
	
	if option_size == 0:
		return
		
	
	show()
	particles.show()
	panel.show()
	get_tree().paused = true
