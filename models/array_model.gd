"""
A plain old one-dimensional random access array.
"""

extends Reference
class_name ArrayModel

var array = []
var size

func _init(size):
	for i in range(1, size + 1):
		array.append(Element.new(i))
	array.shuffle()
	self.size = size

func get(index):
	return array[index]

class Element:
	var value
	var emphasized

	func _init(value):
		self.value = value
		self.emphasized = false
