extends HBoxContainer

var levels

func _ready():
	var descriptions = File.new()
	descriptions.open("res://assets/levels.json", descriptions.READ)
	levels = parse_json(descriptions.get_as_text())
	var first = true
	for level in levels:
		var button = Button.new()
		button.text = level
		button.align = Button.ALIGN_LEFT
		button.connect("focus_entered", self, "_on_Button_focus_changed")
		button.connect("pressed", self, "_on_Button_pressed", [level])
		$LevelsBorder/Levels.add_child(button)
		if first:
			button.grab_focus()
			first = false

func _on_Button_focus_changed():
	$PreviewBorder/Preview/Info.text = levels[get_focus_owner().text]["about"]

func _on_Button_pressed(level):
	scene.change_scene("res://scenes/play.tscn", {"level": level})
