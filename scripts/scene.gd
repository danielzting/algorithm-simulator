"""
Global helper class for passing parameters between changing scenes.
"""

extends Node

var _params = null

func change_scene(next_scene, params=null):
    _params = params
    get_tree().change_scene(next_scene)

func get_param(name, default=null):
    if _params != null and _params.has(name):
        return _params[name]
    return default

func read_save():
    var file = File.new()
    file.open("user://save.json", File.READ)
    return {} if not file.is_open() else parse_json(file.get_as_text())
    file.close()

func write_save(save):
    var file = File.new()
    file.open("user://save.json", File.WRITE)
    file.store_line(to_json(save))
    file.close()
