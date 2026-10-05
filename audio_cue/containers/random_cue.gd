@tool
class_name RandomCue
extends AudioCue

enum RandomType {
	RANDOM,
	SHUFFLE
}

@export var SFX: Array[AudioCue] = []
@export var randomisation_type: RandomType = RandomType.RANDOM

# Shuffle Mode: Maximum amount of times a sample can play before all other samples must be exhausted 
@export_range(1, 10) var max_repetitions: int = 1

@export_group("Randomisation Modifiers")
@export_range(0.0, 4.0) var volume_variance_db: float = 0.0
@export_range(0.0, 0.2) var pitch_variance: float = 0.0

#shuffle mode
var shuffle_pool: Array[AudioCue] = []
var last_played_sample: AudioCue = null

func get_stream() -> AudioStream:
	if(SFX.is_empty()):
		return null
		
	if randomisation_type == RandomType.RANDOM:
		var chosen_stream = SFX.pick_random()
		if chosen_stream:
			return chosen_stream.get_stream()
	else:
		push_error("SHUFFLE RANDOMISATION UNIMPLEMENTED")
		return null
		
	return null
