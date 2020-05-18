extends HBoxContainer

func _ready():
	var file = File.new()
	file.open("res://levels.json", file.READ)
	var levels = parse_json(file.get_as_text())
	for level in levels:
		var button = Button.new()
		button.text = level.name
		button.align = Button.ALIGN_LEFT
		$Tree.add_child(button)
		$VBoxContainer/Info.text = level.documentation
