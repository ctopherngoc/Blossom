extends VBoxContainer

onready var key_list = ['shift', 'ins', 'home', 'pgup', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 'ctrl', 'del', 'end', 'pgdn', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12']
onready var hotkey_scene = preload("res://scenes/userInerface/hotkey.tscn")
onready var item_path = "res://assets/itemSprites/"
#onready var skill_path = "res://assets/abilitySprites/"
onready var grid = $GridContainer

onready var node_list = []

func _ready():
	for key in key_list:
		var hotkey = hotkey_scene.instance()
		hotkey.name = key
		hotkey.get_node("Label").text = " " + key
		var icon_path: String
		
		if Global.player.has("hotkey"):
			pass
		"""
		get hotkey data from character data -> item / skill 
			item
				get icon
				get quantity
			skill
				get icon
				set on press -> call skill
		
		hotkey.icon.texture = load(icon_path)
		"""
		grid.add_child(hotkey)
		node_list.append(hotkey)