extends HBoxContainer
class_name ArrayView

const GREEN = Color(0.2, 1, 0.2)
const ORANGE = Color(1, 0.69, 0)

var level
var rects = []

func _init(level):
	level.connect("mistake", self, "_on_Level_mistake")
	add_child(level)
	self.level = level
	for i in range(level.array.size):
		var rect = ColorRect.new()
		rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rect.size_flags_vertical = Control.SIZE_SHRINK_END
		rects.append(rect)
		add_child(rect)

func _process(delta):
	for i in range(level.array.size):
		rects[i].rect_scale.y = -1 # Override parent Control scale
		rects[i].color = ORANGE if level.emphasized(i) else GREEN
		rects[i].rect_size.y = rect_size.y * level.array.get(i) / level.array.size

func _on_Level_mistake():
	get_parent().flash()
