extends Node

var _params = null

func change_scene(next_scene, params=null):
    _params = params
    get_tree().change_scene(next_scene)

func get_param(name):
    if _params != null and _params.has(name):
        return _params[name]
    return null
