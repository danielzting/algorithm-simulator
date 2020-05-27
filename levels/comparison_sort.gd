extends Node
class_name ComparisonSort

var array: ArrayModel
var index = 0

func _init(array):
	self.array = array

func next(action):
	pass

func emphasized(i):
	pass

func _input(event):
	if event.is_action_pressed("swap"):
		next("swap")
	elif event.is_action_pressed("no_swap"):
		next("no_swap")
