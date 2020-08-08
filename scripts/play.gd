extends VBoxContainer

var _start_time = -1

func _ready():
    $HUDBorder/HUD/Level.text = GlobalScene.get_param("level").NAME

func _process(delta):
    if _start_time >= 0:
        $HUDBorder/HUD/Score.text = "%.3f" % get_score()

func _on_Timer_timeout():
    _start_time = OS.get_ticks_msec()
    $DisplayBorder/Label.queue_free() # Delete ready text
    var level = GlobalScene.get_param("level").new(ArrayModel.new())
    level.connect("done", self, "_on_Level_done")
    $DisplayBorder.add_child(ArrayView.new(level))

func get_score():
    return stepify((OS.get_ticks_msec() - _start_time) / 1000.0, 0.001)

func _on_Level_done():
    var restart = Button.new()
    restart.text = "RESTART LEVEL"
    restart.connect("pressed", self, "_on_Button_pressed", ["play"])
    var separator = Label.new()
    separator.text = " / "
    var back = Button.new()
    back.text = "BACK TO LEVEL SELECT"
    back.connect("pressed", self, "_on_Button_pressed", ["levels"])
    var result = Label.new()
    result.text = "%.3f" % get_score()
    result.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    result.align = Label.ALIGN_RIGHT
    _start_time = -1
    $HUDBorder/HUD/Level.queue_free()
    $HUDBorder/HUD/Score.queue_free()
    $HUDBorder/HUD.add_child(restart)
    $HUDBorder/HUD.add_child(separator)
    $HUDBorder/HUD.add_child(back)
    $HUDBorder/HUD.add_child(result)
    restart.grab_focus()

func _on_Button_pressed(scene):
    GlobalScene.change_scene("res://scenes/" + scene + ".tscn",
        {"level": GlobalScene.get_param("level")})
