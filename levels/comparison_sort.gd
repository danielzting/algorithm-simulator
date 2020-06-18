class_name ComparisonSort
extends Node

signal done
signal mistake

enum ACTIONS {
    SWAP,
    NO_SWAP,

    LEFT,
    RIGHT,
}

const EFFECTS = {
    "NONE": GlobalTheme.GREEN,
    "HIGHLIGHTED": GlobalTheme.ORANGE,
    "DIMMED": GlobalTheme.DARK_GREEN,
    "WUT": 0,
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

    for action in ACTIONS:
        if event.is_action_pressed(action):
            if check(ACTIONS[action]):
                return next()
    if event.is_pressed():
        emit_signal("mistake")

func check(action):
    """Determine if the given action enum value is correct."""
    push_error("NotImplementedError")

func next():
    """Advance the state by one step and signal done if completed."""
    push_error("NotImplementedError")

func _on_ComparisonSort_mistake():
    """Disable the controls for one second."""
    active = false
    _timer.start(DISABLE_TIME)

func _on_Timer_timeout():
    """Reenable the controls."""
    active = true
