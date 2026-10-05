@tool
class_name AudioEvent
extends Resource

@export var play_actions: Array[AudioCue] = []

class EventPayload:
	var stream: AudioStream
	var target_bus: String
	var modifier_data: AudioCue
	var silence_duration: float = 0.0 # Tracks artificial spacing padding

func resolve_event() -> Array[EventPayload]:
	var resolved_actions: Array[EventPayload] = []
	
	for container in play_actions:
		if not container:
			continue
			
		var payload = EventPayload.new()
		payload.target_bus = container.target_bus
		payload.modifier_data = container
		
		# Polymorphic check: evaluate if the node chain hit a Silence block
		if container is SilenceCue:
			payload.silence_duration = container.duration
			payload.stream = null
		elif container is SequenceCue or container is RandomCue:
			# If nested containers contain silence inside them, bubble the property up
			var deep_stream = container.get_stream()
			payload.stream = deep_stream
			# If the resolved nested child was a Silence object, find its length
			if container.get_active_child() is SilenceCue:
				payload.silence_duration = container.get_active_child().duration
		else:
			payload.stream = container.get_stream()
			
		resolved_actions.append(payload)
		
	return resolved_actions
