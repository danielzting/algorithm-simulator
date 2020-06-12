extends VBoxContainer

var start_time = -1

func _ready():
    $HUDBorder/HUD/Level.text = GlobalScene.get_param("level").NAME

func _process(delta):
    if start_time >= 0:
        $HUDBorder/HUD/Score.text = "%.3f" % get_score()

func _on_Timer_timeout():
    start_time = OS.get_ticks_msec()
    $DisplayBorder/Label.queue_free() # Delete ready text
    var level = GlobalScene.get_param("level").new(ArrayModel.new())
    level.connect("done", self, "_on_Level_done")
    $DisplayBorder.add_child(ArrayView.new(level))

func get_score():
    return stepify((OS.get_ticks_msec() - start_time) / 1000.0, 0.001)

func _on_Level_done():
    GlobalScene.change_scene("res://scenes/end.tscn",
        {"level": GlobalScene.get_param("level"), "score": get_score()})
