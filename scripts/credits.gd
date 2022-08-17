extends Label

func _ready():
    var file = File.new()
    file.open("res://CREDITS.md", File.READ)
    text = file.get_as_text()
    file.close()

func _input(event):
    if event.is_pressed():
        GlobalScene.change_scene("res://scenes/menu.tscn", {"keep_music_setting": true})
