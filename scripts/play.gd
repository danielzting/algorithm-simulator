extends VBoxContainer

var start_time = -1

func _ready():
	var label = Label.new()
	label.text = "ready..."
	label.align = Label.ALIGN_CENTER
	label.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	$DisplayBorder/Display.add_child(label)
	$HUDBorder/HUD/Level.text = scene.get_param("level")
	match scene.get_param("level"):
		"BUBBLE SORT":
			pass

func _process(delta):
	var elapsed_time = stepify((OS.get_ticks_msec() - start_time) / 1000.0, 0.001)
	$HUDBorder/HUD/Score.text = "0.000" if start_time == -1 else "%.3f" % elapsed_time

func _on_Timer_timeout():
	$DisplayBorder/Display.get_child(0).queue_free()
	start_time = OS.get_ticks_msec()
