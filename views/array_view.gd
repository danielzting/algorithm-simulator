"""
Visualization of an array as rectangles of varying heights.
"""

class_name ArrayView
extends HBoxContainer

var _level: ComparisonSort
var _rects = []

func _init(level):
    """Add colored rectangles."""
    _level = level
    _level.connect("mistake", self, "_on_Level_mistake")
    add_child(_level) # NOTE: This is necessary for it to read input
    for i in range(level.array.size):
        var rect = ColorRect.new()
        rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        rect.size_flags_vertical = Control.SIZE_SHRINK_END
        _rects.append(rect)
        add_child(rect)

func _process(delta):
    """Update heights of rectangles based on array values."""
    for i in range(_level.array.size):
        _rects[i].rect_scale.y = -1 # HACK: Override scale to bypass weird behavior
        _rects[i].color = _level.get_effect(i)
        _rects[i].rect_size.y = rect_size.y * _level.array.at(i) / _level.array.size

func _on_Level_mistake():
    """Flash the border red on mistakes."""
    get_parent().flash()
