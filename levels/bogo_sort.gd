class_name BogoSort
extends ComparisonSort

const NAME = "BOGOSORT"
const ABOUT = """
Generates random permutations until the array is sorted.
"""
const CONTROLS = """
Keep on hitting RIGHT ARROW to CONTINUE and hope for the best!
"""

func _init(array).(array):
    pass

func check(action):
    return true

func next():
    array = ArrayModel.new(array.size)
    if array.is_sorted():
        emit_signal("done")

func get_effect(i):
    return EFFECTS.NONE
