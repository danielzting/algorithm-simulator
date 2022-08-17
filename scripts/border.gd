"""
A MarginContainer with a flashable colored border around it.
"""

extends MarginContainer

const WIDTH = 5
const FLASHES = 3
const COLOR_CHANGES = FLASHES * 2 - 1

var _color = GlobalTheme.GREEN
var _timer = Timer.new()
var _color_changes = 0

func _ready():
    # Time last return to green with reenabling of controls
    _timer.wait_time = float(ComparisonSort.DISABLE_TIME) / COLOR_CHANGES
    _timer.connect("timeout", self, "_on_Timer_timeout")
    add_child(_timer)

func flash():
    # Immediately flash red and then start timer
    _on_Timer_timeout()
    _timer.start()

func _on_Timer_timeout():
    # Switch between green and red
    if _color_changes == COLOR_CHANGES:
        _timer.stop()
        _color_changes = 0
        _color = GlobalTheme.GREEN
    else:
        _color = GlobalTheme.RED if _color_changes % 2 == 0 else GlobalTheme.GREEN
        _color_changes += 1
    update()

func _draw():
    draw_rect(Rect2(Vector2(), rect_size), _color, false, WIDTH)
