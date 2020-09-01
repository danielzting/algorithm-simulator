extends VBoxContainer

var _start_time = -1
var _level = GlobalScene.get_param("level").new(ArrayModel.new(
    GlobalScene.get_param("size"), GlobalScene.get_param("data_type")))

func _ready():
    set_process(false)
    $HUDBorder/HUD/Level.text = _level.NAME
    _level.connect("done", self, "_on_Level_done")

func _process(delta):
    $HUDBorder/HUD/Score.text = "%.3f" % get_score()

func _on_Timer_timeout():
    set_process(true)
    _start_time = OS.get_ticks_msec()
    $Display/Label.queue_free() # Delete ready text
    $Display.add_child(ArrayView.new(_level))
    _level.set_process_input(true)

func get_score():
    return stepify((OS.get_ticks_msec() - _start_time) / 1000.0, 0.001)

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        _on_Button_pressed("levels")

func _on_Level_done():
    set_process(false)
    var time = get_score()
    var restart = Button.new()
    restart.text = "RESTART LEVEL"
    restart.connect("pressed", self, "_on_Button_pressed", ["play"])
    var separator = Label.new()
    separator.text = " / "
    var back = Button.new()
    back.text = "BACK TO LEVEL SELECT"
    back.connect("pressed", self, "_on_Button_pressed", ["levels"])
    var score = Label.new()
    score.text = "%.3f" % time
    if GlobalScene.get_param("data_type") != ArrayModel.DATA_TYPES.RANDOM_UNIQUE:
        score.text += " (only random unique data counts toward a high score!)"
    else:
        GlobalScore.save_score(_level.NAME, _level.array.size, time)
    score.align = Label.ALIGN_RIGHT
    score.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    $HUDBorder/HUD/Level.queue_free()
    $HUDBorder/HUD/Score.queue_free()
    $HUDBorder/HUD.add_child(restart)
    $HUDBorder/HUD.add_child(separator)
    $HUDBorder/HUD.add_child(back)
    $HUDBorder/HUD.add_child(score)
    restart.grab_focus()

func _on_Button_pressed(scene):
    GlobalScene.change_scene("res://scenes/" + scene + ".tscn",
        {"level": GlobalScene.get_param("level"),
         "size": GlobalScene.get_param("size"),
         "data_type": GlobalScene.get_param("data_type")})
