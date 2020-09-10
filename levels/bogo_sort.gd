class_name BogoSort
extends ComparisonSort

const NAME = "BOGOSORT"
const DESCRIPTION = """
Generates random permutations until the array is sorted.
"""
const CONTROLS = """
Keep on hitting RIGHT ARROW to CONTINUE and hope for the best!
"""
const CODE = """
def bogosort(a):
    while not a.sorted():
        a.shuffle()
"""

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
