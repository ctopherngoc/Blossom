extends SubViewportContainer

@onready var _ViewPort = $SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Video_ViewPortScale(StretchValue):
	#set_stretch_shrink(StretchValue)
	_ViewPort.set_size(StretchValue)
