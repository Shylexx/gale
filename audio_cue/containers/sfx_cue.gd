@tool
class_name SFXCue
extends AudioCue

@export var audio_file: AudioStream

func get_stream() -> AudioStream:
	return audio_file
