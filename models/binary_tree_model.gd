class_name BinaryTreeModel
extends Reference

var left: BinaryTreeModel setget set_left
var right: BinaryTreeModel setget set_right
var parent: BinaryTreeModel
var value = null

func _init(value):
    self.value = value

func set_left(child: BinaryTreeModel):
    child.parent = self
    left = child

func set_right(child: BinaryTreeModel):
    child.parent = self
    right = child
