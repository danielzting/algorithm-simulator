extends ComparisonSort
class_name BogoSort

const TITLE = "BOGOSORT"
const ABOUT = """Generates random permutations until the array is
sorted."""

func _init(array).(array):
    pass

func check(action):
    return true

func next():
    array = ArrayModel.new(array.size)

func emphasized(i):
    return false
