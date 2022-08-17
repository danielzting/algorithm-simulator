class_name ArraySound
extends Node

const SAMPLE_HZ = 44100
const MIN_HZ = 110 # A2

var frac: float
var player = AudioStreamPlayer.new()
var _phase = 0.0
var _playback: AudioStreamGeneratorPlayback

func _fill_buffer(pulse_hz):
    var increment = pulse_hz / SAMPLE_HZ
    for i in range(_playback.get_frames_available()):
        _playback.push_frame(Vector2.ONE * triangle(_phase))
        _phase = fmod(_phase + increment, 1.0)

func _process(delta):
    # Each step of an already sorted array of size 32 <-> one semitone
    _fill_buffer(MIN_HZ * pow(pow(2, 1.0 / 12), frac * 32))

func _init():
    add_child(player)
    player.stream = AudioStreamGenerator.new()
    player.stream.buffer_length = 0.1
    player.stream.mix_rate = SAMPLE_HZ
    _playback = player.get_stream_playback()
    player.play()

func triangle(x):
    """Generate a triangle wave from the given phase."""
    return 2 / PI * asin(sin(PI * x))
