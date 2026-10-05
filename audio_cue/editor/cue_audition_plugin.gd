@tool
extends EditorInspectorPlugin

const CueEditorProperty = preload("res://addons/gale/audio_cue/editor/cue_editor_property.gd")
const CueEventEditorProperty = preload("res://addons/gale/audio_cue/editor/event_editor_property.gd")

func _can_handle(object: Object) -> bool:
	# Intercept the UI if the user selects a container OR a compound multi-voice event
	return object is AudioCue or object is AudioEvent

func _parse_begin(object: Object) -> void:
	if object is AudioEvent:
		var event_property = CueEventEditorProperty.new()
		# Passing an empty string inserts a standalone custom control row at the header
		add_custom_control(event_property)
	
	if object is AudioCue:
		var container_property = CueEditorProperty.new()
		add_custom_control(container_property)
		
