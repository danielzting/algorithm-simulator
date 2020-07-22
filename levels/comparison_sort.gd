class_name ComparisonSort
extends Node

signal done
signal mistake

const ACTIONS = {
    "SWAP": "ui_left",
    "NO_SWAP": "ui_right",

    "LEFT": "ui_left",
    "RIGHT": "ui_right",
}

const EFFECTS = {
    "NONE": GlobalTheme.GREEN,
    "HIGHLIGHTED": GlobalTheme.ORANGE,
    "DIMMED": GlobalTheme.DARK_GREEN,
}

const DISABLE_TIME = 1.0

var array: ArrayModel
var active = true

var _timer = Timer.new()

func _init(array):
    """Initialize array and timer."""
    self.array = array
    _timer.one_shot = true
    _timer.connect("timeout", self, "_on_Timer_timeout")
    add_child(_timer)
    self.connect("mistake", self, "_on_ComparisonSort_mistake")

func _input(event):
    """Pass input events for checking and take appropriate action."""
    if not active:
        return
    for action in ACTIONS.values():
        if event.is_action_pressed(action):
            return next(action)

func next(action):
    """Check the action and advance state or emit signal as needed."""
    push_error("NotImplementedError")

func _on_ComparisonSort_mistake():
    """Disable the controls for one second."""
    active = false
    _timer.start(DISABLE_TIME)

func _on_Timer_timeout():
    """Reenable the controls."""
    active = true
