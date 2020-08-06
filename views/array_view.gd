"""
Visualization of an array as rectangles of varying heights.
"""

class_name ArrayView
extends ViewportContainer

const ANIM_DURATION = 0.1

var _tween = Tween.new()
var _level: ComparisonSort
var _rects = []
var _positions = []
var _unit_width: int
var _unit_height: int
var _viewport = Viewport.new()
onready var _separation = 128 / _level.array.size

func _init(level):
    _level = level
    stretch = true
    _viewport.usage = Viewport.USAGE_2D
    add_child(_level) # NOTE: This is necessary for it to read input
    add_child(_tween) # NOTE: This is necessary for it to animate
    add_child(_viewport)

func _ready():
    yield(get_tree(), "idle_frame")
    _viewport.size = rect_size
    _unit_width = rect_size.x / _level.array.size
    _unit_height = rect_size.y / _level.array.size
    # Keep track of accumulated pixel error from integer division
    var error = float(rect_size.x) / _level.array.size - _unit_width
    var accumulated = 0
    var x = 0
    _level.connect("mistake", get_parent(), "flash")
    for i in range(_level.array.size):
        var rect = Polygon2D.new()
        if accumulated >= 1:
            x += 1
            accumulated -= 1
        rect.polygon = [
            Vector2(0, 0),
            Vector2(0, rect_size.y),
            Vector2(_unit_width - _separation, rect_size.y),
            Vector2(_unit_width - _separation, 0),
        ]
        accumulated += error
        rect.position = Vector2(x, rect_size.y)
        _positions.append(x)
        x += _unit_width
        _rects.append(rect)
        _viewport.add_child(rect)
    _level.array.connect("swapped", self, "_on_ArrayModel_swapped")
    _level.array.connect("sorted", self, "_on_ArrayModel_sorted")

func _process(delta):
    for i in range(_rects.size()):
        _rects[i].color = _level.get_effect(i)
        _rects[i].scale.y = -float(_level.array.at(i)) / _level.array.size

func _on_ArrayModel_swapped(i, j):
    var time = ANIM_DURATION * (1 + float(j - i) / _level.array.size)
    _tween.interpolate_property(
        _rects[i], "position:x", null, _positions[j], time)
    _tween.interpolate_property(
        _rects[j], "position:x", null, _positions[i], time)
    var temp = _rects[i]
    _rects[i] = _rects[j]
    _rects[j] = temp
    _tween.start()

func _on_ArrayModel_sorted(i, j):
    for x in range(i, j):
        _rects[x].position.y = 0
    for x in range(i, j):
        _tween.interpolate_property(
            _rects[x], "position:y", null, rect_size.y, ANIM_DURATION)
    _tween.start()
