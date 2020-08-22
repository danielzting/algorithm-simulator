"""
BOGOSORT

Generates random permutations until the array is sorted.

Keep on hitting RIGHT ARROW to CONTINUE and hope for the best!
"""

class_name BogoSort
extends ComparisonSort

func _init(array).(array):
    pass

func next(action):
    array = ArrayModel.new(array.size)
    if array.is_sorted():
        emit_signal("done")

func get_effect(i):
    return EFFECTS.NONE

func get_frac():
    return array.frac(0)
