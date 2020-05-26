extends VBoxContainer

var start_time = -1

func _ready():
	$HUDBorder/HUD/Level.text = scene.get_param("level")
	# Show ready text
	var label = Label.new()
	label.text = "ready..."
	label.align = Label.ALIGN_CENTER
	label.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	$DisplayBorder.add_child(label)

func _process(delta):
	# Show elapsed time in milliseconds
	var elapsed_time = stepify((OS.get_ticks_msec() - start_time) / 1000.0, 0.001)
	$HUDBorder/HUD/Score.text = "0.000" if start_time == -1 else "%.3f" % elapsed_time

func _on_Timer_timeout():
	start_time = OS.get_ticks_msec()
	# Delete ready text
	$DisplayBorder.get_child(0).queue_free()
	# Load level
	var array = ArrayModel.new(10)
	var level
	match scene.get_param("level"):
		"BUBBLE SORT":
			level = BubbleSort.new(array)
	$DisplayBorder.add_child(ArrayView.new(level))
