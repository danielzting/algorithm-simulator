class_name ComparisonSort
extends Node

signal done
signal mistake

const EFFECTS = {
    "NONE": GlobalTheme.GREEN,
    "HIGHLIGHTED": GlobalTheme.ORANGE,
    "DIMMED": GlobalTheme.DARK_GREEN,
}

const DISABLE_TIME = .5

var array: ArrayModel

var _timer = Timer.new()

func _init(array):
    """Initialize array and timer."""
    self.array = array
    _timer.one_shot = true
    _timer.connect("timeout", self, "_on_Timer_timeout")
    add_child(_timer)
    self.connect("mistake", self, "_on_ComparisonSort_mistake")
    self.connect("done", self, "_on_ComparisonSort_done")

func _ready():
    set_process_input(false)

func _input(event):
    """Pass input events for checking and take appropriate action."""
    if event is InputEventKey and event.is_pressed():
        return next(event.as_text())
    if event is InputEventMouseButton and event.is_pressed():
        if event.position.x < ProjectSettings.get_setting("display/window/size/width") / 2:
            return next("Left")
        else:
            return next("Right")

func next(action):
    """Check the action and advance state or emit signal as needed."""
    push_error("NotImplementedError")

func _on_ComparisonSort_done():
    set_process_input(false)

func _on_ComparisonSort_mistake():
    """Disable the controls for one second."""
    set_process_input(false)
    _timer.start(DISABLE_TIME)

func _on_Timer_timeout():
    """Reenable the controls."""
    set_process_input(true)
