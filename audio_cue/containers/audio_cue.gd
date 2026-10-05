@tool
class_name AudioCue
extends Resource

@export var target_bus: String = "SFX"

# Override this for new types of audio cue/container
func get_stream() -> AudioStream:
	return null
