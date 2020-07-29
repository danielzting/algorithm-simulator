"""
Visualization of an array as rectangles of varying heights.
"""

class_name ArrayView
extends HBoxContainer

const SWAP_DURATION = 0.1

var _tween = Tween.new()
var _level: ComparisonSort
var _rects = []
# Save initial positions to prevent animation race condition
var _positions = []
var _unit_height: int

func _init(level):
    """Add colored rectangles."""
    _level = level
    _level.array.connect("swapped", self, "_on_ArrayModel_swapped")
    add_child(_level) # NOTE: This is necessary for it to read input
    for i in range(level.array.size):
        var rect = ColorRect.new()
        rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        rect.size_flags_vertical = Control.SIZE_SHRINK_END
        _rects.append(rect)
        add_child(rect)
    add_child(_tween) # NOTE: This is necessary for it to animate
    _positions.resize(_level.array.size)

func _ready():
    _level.connect("mistake", get_parent(), "flash")

func _draw():
    # HACK: Workaround for resized signal not firing when window resized
    _unit_height = rect_size.y / _level.array.size
    for i in range(_rects.size()):
        _rects[i].rect_scale.y = -1
        _positions[i] = _rects[i].rect_position

func _process(delta):
    """Update heights of rectangles based on array values."""
    for i in range(_rects.size()):
        _rects[i].color = _level.get_effect(i)
        _rects[i].rect_size.y =  _level.array.at(i) * _unit_height

func _on_ArrayModel_swapped(i, j):
    """Produce a swapping animation."""
    var time = SWAP_DURATION * (1 + float(j - i) / _level.array.size)
    _tween.interpolate_property(
        _rects[i], "rect_position", null, _positions[j], time)
    _tween.interpolate_property(
        _rects[j], "rect_position", null, _positions[i], time)
    var temp = _rects[i]
    _rects[i] = _rects[j]
    _rects[j] = temp
    _tween.start()
