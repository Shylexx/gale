class_name SilenceCue
extends AudioCue

@export_range(0.0, 10.0, 0.05, "suffix:s") var duration: float = 1.0

func get_stream() -> AudioStream:
	return null
