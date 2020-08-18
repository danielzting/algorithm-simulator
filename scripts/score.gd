"""
Common helper library for scoring functions.
"""

extends Node

const TIERS = ["F", "D", "C", "B", "A", "S"]
const COLORS = [
    Color("f44336"),
    Color("ff9800"),
    Color("ffeb3b"),
    Color("4caf50"),
    Color("03a9f4"),
    Color("e040fb"),
]

var _save: Dictionary

func _init():
    var file = File.new()
    file.open("user://save.json", File.READ)
    _save = {} if not file.is_open() else parse_json(file.get_as_text())
    file.close()

func get_time(name, size):
    if name in _save and str(size) in _save[name]:
        return _save[name][str(size)][0]
    return INF

func get_tier(name, size):
    if name in _save and str(size) in _save[name]:
        return _save[name][str(size)][1]
    return ""

func get_color(name, size):
    var tier = get_tier(name, size)
    return Color.black if tier.empty() else COLORS[TIERS.find(tier)]

func calculate_tier(time, moves):
    return TIERS[min(int(moves / time), TIERS.size() - 1)]

func calculate_color(time, moves):
    return COLORS[TIERS.find(calculate_tier(time, moves))]

func save_score(name, size, time, moves):
    if not name in _save:
        _save[name] = {}
    if not str(size) in _save[name]:
        _save[name][str(size)] = [INF, ""]
    var prev_time = get_time(name, size)
    var prev_tier = get_tier(name, size)
    var tier = calculate_tier(time, moves)
    var tier_index = TIERS.find(tier)
    if (prev_tier.empty() or tier_index > TIERS.find(prev_tier)
        or tier_index == TIERS.find(prev_tier) and time < prev_time):
        _save[name][str(size)] = [time, tier]
    _save()

func _save():
    var file = File.new()
    file.open("user://save.json", File.WRITE)
    file.store_line(to_json(_save))
    file.close()
