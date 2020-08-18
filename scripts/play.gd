extends VBoxContainer

var _start_time = -1
var _level = GlobalScene.get_param(
    "level", preload("res://scripts/levels.gd").LEVELS[0])

func _ready():
    $HUDBorder/HUD/Level.text = _level.new(ArrayModel.new()).NAME

func _process(delta):
    if _start_time >= 0:
        $HUDBorder/HUD/Score.text = "%.3f" % get_score()

func _on_Timer_timeout():
    _start_time = OS.get_ticks_msec()
    $Display/Label.queue_free() # Delete ready text
    var level = _level.new(ArrayModel.new(
        GlobalScene.get_param("size", ArrayModel.DEFAULT_SIZE)))
    level.connect("done", self, "_on_Level_done", [level])
    $Display.add_child(ArrayView.new(level))
    level.set_process_input(true)

func get_score():
    return stepify((OS.get_ticks_msec() - _start_time) / 1000.0, 0.001)

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        _on_Button_pressed("levels")

func _on_Level_done(level):
    var moves = level.moves
    var score = get_score()
    var restart = Button.new()
    restart.text = "RESTART LEVEL"
    restart.connect("pressed", self, "_on_Button_pressed", ["play"])
    var separator = Label.new()
    separator.text = " / "
    var back = Button.new()
    back.text = "BACK TO LEVEL SELECT"
    back.connect("pressed", self, "_on_Button_pressed", ["levels"])
    var time = Label.new()
    time.text = "%.3f" % score
    time.align = Label.ALIGN_RIGHT
    time.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _start_time = -1
    var tier = Label.new()
    tier.text = Score.get_tier(moves, score)
    tier.align = Label.ALIGN_RIGHT
    tier.add_color_override("font_color", Score.get_color(moves, score))
    $HUDBorder/HUD/Level.queue_free()
    $HUDBorder/HUD/Score.queue_free()
    $HUDBorder/HUD.add_child(restart)
    $HUDBorder/HUD.add_child(separator)
    $HUDBorder/HUD.add_child(back)
    $HUDBorder/HUD.add_child(time)
    $HUDBorder/HUD.add_child(tier)
    restart.grab_focus()
    var save = GlobalScene.read_save()
    var name = level.NAME
    var size = str(GlobalScene.get_param("size", ArrayModel.DEFAULT_SIZE))
    if not name in save:
        save[name] = {}
    if not size in save[name]:
        save[name][size] = [-1, INF]
    var mps1 = Score.get_mps_int(moves, score)
    var mps2 = Score.get_mps_int(save[name][size][0], save[name][size][1])
    if mps1 > mps2 or mps1 == mps2 and score < save[name][size][1]:
        save[name][size] = [moves, score]
    GlobalScene.write_save(save)

func _on_Button_pressed(scene):
    GlobalScene.change_scene("res://scenes/" + scene + ".tscn",
        {"level": _level, "size": GlobalScene.get_param("size")})
