extends Control
signal move_to_top

onready var equipment_tab  = {
	"faceacc": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer/Face,
	"headgear": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer/Head,
	"earring": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer/Earring,
	"ammo": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer2/Ammo,
	"top": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer2/Top,
	"glove": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer2/Glove,
	"lweapon": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer3/Lhand,
	"bottom":$Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer3/Bottom,
	"rweapon":$Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer3/Rhand,
	"eyeacc": $Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer4/Eye,
	"tattoo":$Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer4/Tattoo,
	"pocket":$Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer4/Pocket,
	"ring1":$Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer5/Ring1,
	"ring2":$Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer5/Ring2,
	"ring3":$Background/M/V/TabContainer/Equip/MarginContainer/VBoxContainer/HBoxContainer5/Ring3,
}
onready var equipment_string  = {
	"faceacc": "face",
	"headgear": "head",
	"earring": "earring",
	"ammo": "ammo",
	"top": "top",
	"glove": "glove",
	"lweapon": "lhand",
	"bottom": "bottom",
	"rweapon": "rhand",
	"eyeacc": "eye",
	"tattoo": "tattoo",
	"pocket": "pocket",
	"ring1":"ring",
	"ring2": "ring",
	"ring3": "ring",
}

onready var equipment_ref
#onready var equipment_ref = GameData.test_player.equipment
onready var item_path = "res://assets/itemSprites/equipItems/"
onready var initialize = 0
var drag_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	Signals.connect("update_equipment", self, "populate_equipment")
	Signals.connect("toggle_equipment", self, "toggle_equipment")
	populate_equipment()
	"""
	update to own function instead of _Ready so it can be called by
	_ready and also when update inventory
	Drag and Drop Inventory System | Godot Tutorial
	https://www.youtube.com/watch?v=dZYlwmBCziM
	"""
	# scroll through tabs (equip, use, etc) notmade yet
func populate_equipment():
	# inventory_tabs can be changed to global.player.inventory
	equipment_ref = Global.player.equipment
	var equipment_key = equipment_ref.keys()
	for slot in equipment_key:
			
		equipment_tab[slot].label.text = equipment_string[slot]
			
		if not equipment_tab[slot].slot:
			equipment_tab[slot].slot = slot
			#equipment_tab[slot].type = equipment_string[slot]
			
		if typeof(equipment_ref[slot]) == TYPE_NIL:
			equipment_tab[slot].icon.texture = null
			equipment_tab[slot].background.texture = load(equipment_tab[slot].empty_bg)
			continue
			
		if typeof(equipment_ref[slot]) == TYPE_INT:
			if equipment_ref[slot] == -1:
				equipment_tab[slot].icon.texture = null
				equipment_tab[slot].background.texture = load(equipment_tab[slot].empty_bg)
			else:
				equipment_tab[slot].icon.texture = load(str(item_path + str(equipment_ref[slot]) + ".png"))
				equipment_tab[slot].background.texture = load(equipment_tab[slot].used_bg)
		else:
				equipment_tab[slot].icon.texture = load(str(item_path + str(equipment_ref[slot].id) + ".png"))
				equipment_tab[slot].background.texture = load(equipment_tab[slot].used_bg)
				
				equipment_tab[slot].item_data["id"] = equipment_ref[slot].id
				equipment_tab[slot].item_data["item"] = equipment_ref[slot]

#
#func update_equipment():
#	# inventory_tabs can be changed to global.player.inventory
#	inv_ref = Global.player.inventory
#	for tab in inv_ref:
#		if tab == "100000":
#			gold_label.text = str(inv_ref[tab])
#		else:
#			var count = 0
#			max_slots = inv_ref[tab].size()
#			# for item in each tab
#			while count < max_slots:
#
#				if inv_ref[tab][count] != null:
#					# get item node from node_list
#					var item = inv_ref[tab][count]
#					var item_node = node_list[tab][count]
#					#print("in update inventory, item: %s" % item)
#					var _item_name = GameData.itemTable[str(item['id'])]["itemName"]
#					item_node.item_data["id"] = str(item['id'])
#					item_node.item_data["item"] = GameData.itemTable[str(item['id'])]["itemName"]
#					# if stackable exit number on iventory slot
#					if tab in stackable_tabs:
#						item_node.label.text = str(item["q"])
#						item_node.item_data["q"]= item["q"]
#					if tab == "equipment":
#						var temp_item_path = item_path + "equipItems/" + inv_ref[tab][count]["id"] + ".png"
#						item_node.icon.texture = load(temp_item_path)
#					elif tab == "use":
#						var temp_item_path = item_path + "useItems/" + inv_ref[tab][count]["id"] + ".png"
#						item_node.icon.texture = load(temp_item_path)
#					elif tab == "etc":
#						var temp_item_path = item_path + "etcItems/" + inv_ref[tab][count]["id"] + ".png"
#						item_node.icon.texture = load(temp_item_path)
#				else:
#					var item_node = node_list[tab][count]
#					item_node.item_data = {"id": null,"item": null, "q": null}
#					item_node.icon.set_texture(null)
#				count += 1

func _on_Header_gui_input(event):
	if event is InputEventMouseButton:
		# left mouse button
		if event.pressed && event.get_button_index() == 1:
			print("left mouse button")
			drag_position = get_global_mouse_position() - rect_global_position
			emit_signal('move_to_top', self)
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
			

"""
func update inventory

Required to add rpc calls to server to swap inventory data.
Server remove func to validate item move request -> 
update server char inventory data -> client remote func to update character data ->
 update inventory window icons (similar to health hud)
"""

#func test_setup():
#	inventory_tabs = inv_ref.keys()
#	for key in inventory_tabs:
#		if key != "100000":
#			var count = 0
#			while count < max_slots:
#				inv_ref[key].append(null)
#				count += 1
#	#var inventory_tabs = Global.player.inventory.keys()
#	#var inv_ref = Global.player.inventory
#	inv_ref["use"][0] = {'id': "300001", 'q': 5}
#	inv_ref["use"][1] = {'id': "300002", 'q': 500}
#	inv_ref["use"][6] = {'id': "300003", 'q': 420}
#	inv_ref["equipment"][1] = {'id': "500004"}
#	inv_ref["equipment"][6] = {'id': "500005"}
#	inv_ref["100000"] = 123456789


func _on_TabContainer_tab_selected(_tab):
	AudioControl.play_audio("menuClick")
	
func toggle_equipment():
	self.visible = not self.visible