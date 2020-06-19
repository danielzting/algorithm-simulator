"""
Visualization of an array as rectangles of varying heights.
"""

class_name ArrayView
extends HBoxContainer

var level: ComparisonSort
var rects = []

func _init(level):
    """Add colored rectangles."""
    level.connect("mistake", self, "_on_Level_mistake")
    self.level = level
    add_child(level) # NOTE: This is necessary for it to read input
    for i in range(level.array.size):
        var rect = ColorRect.new()
        rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        rect.size_flags_vertical = Control.SIZE_SHRINK_END
        rects.append(rect)
        add_child(rect)

func _process(delta):
    """Update heights of rectangles based on array values."""
    for i in range(level.array.size):
        rects[i].rect_scale.y = -1 # HACK: Override scale to bypass weird behavior
        rects[i].color = level.get_effect(i)
        rects[i].rect_size.y = rect_size.y * level.array.get(i) / level.array.size

func _on_Level_mistake():
    """Flash the border red on mistakes."""
    get_parent().flash()
