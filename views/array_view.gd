"""
Visualization of an array as rectangles of varying heights.
"""

class_name ArrayView
extends HBoxContainer

const SWAP_DURATION = 0.1
const TRANS_TYPE = Tween.TRANS_LINEAR
const EASE_TYPE = Tween.EASE_IN_OUT

var _tween = Tween.new()
var _level: ComparisonSort
var _rects = []

func _init(level):
    """Add colored rectangles."""
    _level = level
    _level.connect("mistake", self, "_on_Level_mistake")
    _level.array.connect("swapped", self, "_on_ArrayModel_swapped")
    add_child(_level) # NOTE: This is necessary for it to read input
    for i in range(level.array.size):
        var rect = ColorRect.new()
        rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        rect.size_flags_vertical = Control.SIZE_SHRINK_END
        _rects.append(rect)
        add_child(rect)
    add_child(_tween) # NOTE: This is necessary for it to animate

func _process(delta):
    """Update heights of rectangles based on array values."""
    for i in range(_level.array.size):
        _rects[i].rect_scale.y = -1 # HACK: Override scale to bypass weird behavior
        _rects[i].color = _level.get_effect(i)
        _rects[i].rect_size.y = rect_size.y * _level.array.at(i) / _level.array.size

func _on_Level_mistake():
    """Flash the border red on mistakes."""
    get_parent().flash()

func _on_ArrayModel_swapped(i, j):
    """Produce a swapping animation."""
    _tween.interpolate_property(_rects[i], "rect_position",
        null, _rects[j].rect_position, SWAP_DURATION, TRANS_TYPE, EASE_TYPE)
    _tween.interpolate_property(_rects[j], "rect_position",
        null, _rects[i].rect_position, SWAP_DURATION, TRANS_TYPE, EASE_TYPE)
    var temp = _rects[i]
    _rects[i] = _rects[j]
    _rects[j] = temp
    _tween.start()
