extends Control

onready var sound_node = $PanelContainer/TabContainer/Sound
onready var video_node = $PanelContainer/TabContainer/Video
onready var option_path = "user://gameOption.dat"

func _ready() -> void:
	load_settings()

func _on_back_pressed() -> void:
	save_settings()

func load_settings() -> void:
	var save_file = File.new()
	if not save_file.file_exists(option_path):
		return
	save_file.open(option_path, File.READ)
	var settings_data = JSON.parse(save_file.get_as_text())
	var sound_settings = settings_data.result["sound"]
	sound_node.masterValue = float(sound_settings.master)
	sound_node.effectValue = float(sound_settings.effect)
	sound_node.musicValue = float(sound_settings.music)
	sound_node.set_sound_values()
	print("Loaded")
	save_file.close()

func save_settings() -> void:
	sound_node.save_sound_values()
	var file = File.new()
	file.open(option_path, file.WRITE)
	var data ={"sound": {
		"master": sound_node.masterValue,
		"music": sound_node.musicValue,
		"effect": sound_node.effectValue,
		}
	}
	file.store_line(JSON.print(data, "\t"))
	#file.store_var(data)
	file.close()
"""
if Resolutions[r] == CurrentResolution:
			ResolutionOptionButton._select_int(index)
"""
