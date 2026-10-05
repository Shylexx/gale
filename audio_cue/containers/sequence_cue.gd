class_name SequenceContainer
extends AudioCue

@export var sequence: Array[AudioCue] = []

var _current_index: int = 0
var _last_picked: AudioCue

func get_stream() -> AudioStream:
	if sequence.is_empty():
		return null
	
	_last_picked = sequence[_current_index]
	
	var next_stream = sequence[_current_index]
	_current_index = (_current_index + 1) % sequence.size()
	
	if next_stream:
		return next_stream.get_stream()
		
	return null
