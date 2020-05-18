extends MarginContainer

var GREEN = Color(0.2, 1, 0.2)
var WIDTH = 5

func _ready():
	pass

func _draw():
	draw_rect(Rect2(Vector2(), rect_size), GREEN, false, WIDTH)
