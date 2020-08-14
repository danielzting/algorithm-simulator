"""
Common helper library for scoring functions.
"""
class_name Score
extends Reference

const TIERS = ["F", "D", "C", "B", "A", "S"]
const COLORS = [
    Color("f44336"),
    Color("ff9800"),
    Color("ffeb3b"),
    Color("4caf50"),
    Color("03a9f4"),
    Color("e040fb"),
]

static func get_tier(moves, seconds):
    return TIERS[get_mps_int(moves, seconds)]

static func get_mps_int(moves, seconds):
    return min(moves / seconds, TIERS.size() - 1)

static func get_color(moves, seconds):
    return COLORS[min(moves / seconds, COLORS.size() - 1)]
