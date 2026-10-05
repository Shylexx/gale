@tool
class_name SequenceCue
extends AudioCue

enum SequencePlayMode {
	Step,
	Continuous
}

@export var sequence: Array[AudioCue] = []
@export var play_mode: SequencePlayMode = SequencePlayMode.Step

var _current_index: int = 0
var _last_picked: AudioCue

func get_stream() -> AudioStream:
	if sequence.is_empty():
		return null
		
	if play_mode == SequencePlayMode.Step:
		_last_picked = sequence[_current_index]
		
		var next_stream = sequence[_current_index]
		_current_index = (_current_index + 1) % sequence.size()
		
		if next_stream:
			return next_stream.get_stream()
	# TODO: implement Continuous Play mode
	else:
		push_error("SEQUENCE CONTINUOUS PLAY MODE UNIMPLEMENTED")
	return null
