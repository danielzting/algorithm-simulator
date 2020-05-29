extends Node
class_name ComparisonSort

signal done
signal mistake

const ACTIONS = ["swap", "no_swap"]

var array: ArrayModel
var index = 0
var timer = Timer.new()
var active = true

func _init(array):
	self.array = array
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)
	self.connect("mistake", self, "_on_ComparisonSort_mistake")

func check(action):
	pass

func next():
	pass

func _on_ComparisonSort_mistake():
	active = false
	timer.start(1)

func _on_Timer_timeout():
	active = true

func _input(event):
	if not active:
		return

	for action in ACTIONS:
		if event.is_action_pressed(action):
			if check(action):
				next()
			else:
				emit_signal("mistake")
