extends MarginContainer

const GREEN = Color(0.2, 1, 0.2)
const RED = Color(1, 0, 0)
const WIDTH = 5
var color = GREEN
var timer = Timer.new()
const FLASHES = 3
var color_changes = 0

func _ready():
	# Input should be reenabled right after the last red flash
	timer.wait_time = 1.0 / (FLASHES * 2 - 1)
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)

func flash():
	_on_Timer_timeout()
	timer.start()

func _on_Timer_timeout():
	if color_changes == FLASHES * 2 - 1:
		timer.stop()
		color_changes = 0
		color = GREEN
	else:
		color = RED if color_changes % 2 == 0 else GREEN
		color_changes += 1
	update()

func _draw():
	draw_rect(Rect2(Vector2(), rect_size), color, false, WIDTH)
