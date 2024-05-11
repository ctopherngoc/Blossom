extends CanvasLayer

#onready var current_scene_container = preload("res://scenes/menuObjects/LoginScreen/LoginScreen.tscn")
#onready var current_scene = "menu"
onready var current_bgm = "menu"
# menu hash map
onready var menu_scenes = {
	"mainMenu" : "res://scenes/menuObjects/mainMenu.tscn",
	"register" : "res://scenes/menuObjects/RegisterScreen/RegisterScreen.tscn",
	"login" : "res://scenes/menuObjects/LoginScreen/LoginScreen.tscn",
	"characterSelect" : "res://scenes/menuObjects/CharacterSelect/UserProfile.tscn",
	"create": "res://scenes/menuObjects/CharacterCreate/Create.tscn",
}

func _ready() -> void:
	pass

func _process(_delta):
	pass

func change_scene(scene: String) -> void:
# warning-ignore:return_value_discarded
	# if in menu
	# makes screen black
	if Global.in_game:
			get_node("/root/currentScene").visible = false
	$AnimationPlayer.play("dissolve")
	yield($AnimationPlayer, "animation_finished")
	if scene in menu_scenes.keys():
		get_tree().change_scene(menu_scenes[scene])
		if current_bgm != "menu":
			AudioControl.bgm.set_stream(GameData.bgm_dict["menu"])
			current_bgm = "menu"
	else:
		# if in map
		Global.current_map = scene
		print(Global.current_map, " ", GameData.map_dict[scene]["name"])
		
		# if map different bgm
		if GameData.map_dict[scene]["bgm"] != current_bgm:
			print("%s != %s" % [GameData.map_dict[scene]["bgm"], current_bgm])
			current_bgm = GameData.map_dict[scene]["bgm"]
			AudioControl.bgm.set_stream(GameData.bgm_dict[GameData.map_dict[scene]["bgm"]])
			AudioControl.bgm.play()
		# warning-ignore:return_value_discarded
		get_tree().change_scene(GameData.map_dict[scene]["path"])
		if Global.in_game:
			get_node("/root/currentScene").visible = true
	$AnimationPlayer.play_backwards("dissolve")
	
#func _unhandled_input(event):
#	if event.pressed and event.scancode == KEY_SPACE:
#		get_node("/root/currentScene").visible = false
#		$AnimationPlayer.play("dissolve")
#		yield($AnimationPlayer, "animation_finished")
#		get_node("/root/currentScene").visible = true
#		$AnimationPlayer.play_backwards("dissolve")
