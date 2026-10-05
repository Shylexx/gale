@tool
extends EditorProperty

var play_button: Button = Button.new()
var current_event: AudioEvent

func _init() -> void:
	play_button.text = "▶ Fire Audio Event"
	play_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	play_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	add_child(play_button)
	set_bottom_editor(play_button)
	
	play_button.pressed.connect(_on_play_pressed)

func _update_property() -> void:
	current_event = get_edited_object() as AudioEvent

func _on_play_pressed() -> void:
	if not current_event or current_event.play_actions.is_empty():
		push_warning("AudioEngine: Cannot audition. AudioEvent is empty or unassigned.")
		return

	# 1. Resolve all nested container streams simultaneously
	var payloads: Array = current_event.resolve_event()
	if payloads.is_empty():
		return

	# Set the button cursor visual state while processing concurrent voices
	play_button.mouse_default_cursor_shape = Control.CURSOR_BUSY
	play_button.disabled = true

	# Keep track of active preview nodes to safely restore cursor state when the event completes
	var active_previews: Array[AudioStreamPlayer] = []

	for payload in payloads:
		var bus_index = AudioServer.get_bus_index(payload.target_bus)
		var final_bus = payload.target_bus if bus_index != -1 else "Master"

		# 2. Instantiate isolated editor hardware voices
		var preview_player = AudioStreamPlayer.new()
		EditorInterface.get_base_control().add_child(preview_player)
		active_previews.append(preview_player)
		
		preview_player.stream = payload.stream
		preview_player.bus = final_bus
		
		# 3. Handle random variation modifiers inside the editor preview
		_apply_preview_modifiers(preview_player, payload.modifier_data)
		
		preview_player.finished.connect(func():
			active_previews.erase(preview_player)
			preview_player.queue_free()
			
			# Revert cursor and lock status once all layers finish
			if active_previews.is_empty():
				play_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
				play_button.disabled = false
		)
		
		preview_player.play()

func _apply_preview_modifiers(player: AudioStreamPlayer, source_container: AudioCue) -> void:
	if source_container is RandomCue:
		var vol_offset: float = randf_range(-source_container.volume_variance_db, 0.0)
		var pitch_offset: float = randf_range(1.0 - source_container.pitch_variance, 1.0 + source_container.pitch_variance)
		
		player.volume_db += vol_offset
		player.pitch_scale *= pitch_offset
