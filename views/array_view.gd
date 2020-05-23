extends HBoxContainer
class_name ArrayView

const GREEN = Color(0.2, 1, 0.2)
const ORANGE = Color(1, 0.69, 0)

var model: ArrayModel
var rects = []

func _init(model):
	self.model = model
	for i in range(model.size):
		var rect = ColorRect.new()
		rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rect.size_flags_vertical = Control.SIZE_SHRINK_END
		rect.color = GREEN
		rects.append(rect)
		add_child(rect)

func _draw():
	for i in range(model.size):
		rects[i].rect_scale.y = -1 # Override parent Control scale
		rects[i].rect_size.y = rect_size.y * model.get(i).value / model.size
