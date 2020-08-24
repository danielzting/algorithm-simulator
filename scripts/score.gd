"""
Common helper library for scoring functions.
"""

extends Node

const VERSION = 0 # Increment when changing save file format

var _save: Dictionary

func _init():
    var file = File.new()
    file.open("user://save.json", File.READ)
    _save = {} if not file.is_open() else parse_json(file.get_as_text())
    file.close()

func get_time(name, size):
    if name in _save and str(size) in _save[name]:
        return _save[name][str(size)]
    return INF

func save_score(name, size, time):
    if not name in _save:
        _save[name] = {}
    if not str(size) in _save[name]:
        _save[name][str(size)] = INF
    _save[name][str(size)] = min(time, get_time(name, size))
    _save()

func _save():
    _save["VERSION"] = VERSION
    var file = File.new()
    file.open("user://save.json", File.WRITE)
    file.store_line(to_json(_save))
    file.close()
