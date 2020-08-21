class_name ArraySound
extends Node

const SAMPLE_HZ = 44100
const MIN_HZ = 110
const MAX_HZ = 440

var frac: float
var player = AudioStreamPlayer.new()
var _phase = 0.0
var _playback: AudioStreamGeneratorPlayback

func _fill_buffer(pulse_hz):
    var increment = pulse_hz / SAMPLE_HZ
    for i in range(_playback.get_frames_available()):
        _playback.push_frame(Vector2.ONE * sin(_phase * TAU))
        _phase = fmod(_phase + increment, 1.0)

func _process(delta):
    _fill_buffer(MIN_HZ + (MAX_HZ - MIN_HZ) * frac)

func _init():
    add_child(player)
    player.stream = AudioStreamGenerator.new()
    player.stream.buffer_length = 0.05
    player.stream.mix_rate = SAMPLE_HZ
    _playback = player.get_stream_playback()
    player.play()
