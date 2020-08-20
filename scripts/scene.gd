"""
Global helper class for passing parameters between changing scenes.
"""

extends Node

var _params = null

func change_scene(next_scene, params=null):
    _params = params
    get_tree().change_scene(next_scene)

func get_param(name, default=null):
    if _params != null and _params.get(name) != null:
        return _params[name]
    return default
