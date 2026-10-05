extends EditorProperty

var play_button: Button = Button.new()
var stop_button: Button = Button.new()
var current_cue: AudioCue

func _init() -> void:
	play_button.text = "▶ Play Event"
	play_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	play_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	stop_button.text = "■ Stop Event"
	stop_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	stop_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	add_child(play_button)
	add_child(stop_button)
	set_bottom_editor(stop_button)
	
	play_button.pressed.connect(_on_play_pressed)
	stop_button.pressed.connect(_on_stop_pressed)

func _update_property() -> void:
	current_cue = get_edited_object() as AudioCue
	
func _on_play_pressed() -> void:
	if not current_cue:
		return
		
# Ask the container to resolve its own playback logic
	var chosen_stream: AudioStream = current_cue.get_stream()
	if not chosen_stream:
		push_warning("AudioEngine: Container returned no stream.")
		return

	var bus_index = AudioServer.get_bus_index(current_cue.target_bus)
	var final_bus = current_cue.target_bus if bus_index != -1 else "Master"

	play_button.mouse_default_cursor_shape = Control.CURSOR_BUSY
	play_button.disabled = true 

	var preview_player = AudioStreamPlayer.new()
	EditorInterface.get_base_control().add_child(preview_player)
	
	preview_player.stream = chosen_stream
	preview_player.bus = final_bus
	
	# Apply modifiers if this specific container is a RandomContainer
	if current_cue is RandomCue:
		var vol_offset: float = randf_range(-current_cue.volume_variance_db, 0.0)
		var pitch_offset: float = randf_range(1.0 - current_cue.pitch_variance, 1.0 + current_cue.pitch_variance)
		preview_player.volume_db += vol_offset
		preview_player.pitch_scale *= pitch_offset
	
	preview_player.finished.connect(func():
		play_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		play_button.disabled = false
		preview_player.queue_free()
	)
	
	preview_player.play()
	
func _on_stop_pressed() -> void:
	pass
