@tool
extends Node

signal parameter_changed(param_name: String, new_value: float)

# TODO: Make it easier to register custom parameters, maybe like this?
@export var parameters: Dictionary[String, float] = {
	"rain_intensity": 1.0,
}

@export var mappings: Array[RTPCMapping] = []

func set_parameter(param_name: String, value: float) -> void:
	# clamp to resource max + min parameter
	value = clamp(value, 0.0, 1.0)
	parameters[param_name] = value
	parameter_changed.emit(param_name, value)
	
func get_parameter(param_name: String) -> float:
	return parameters.get(param_name)

func _ready() -> void:
	# Connect to the global parameter manager signal
	parameter_changed.connect(_on_parameter_changed)
	
	# Initialise all mappings to match current starting states
	for mapping in mappings:
		var current_val = get_parameter(mapping.parameter_name)
		_apply_mapping(mapping, current_val)

func _on_parameter_changed(param_name: String, new_value: float) -> void:
	for mapping in mappings:
		if mapping.parameter_name == param_name:
			_apply_mapping(mapping, new_value)

func _apply_mapping(mapping: RTPCMapping, raw_value: float) -> void:
	var bus_idx = AudioServer.get_bus_index(mapping.target_bus)
	if bus_idx == -1:
		push_error("RTPC Error: Bus not found - " + mapping.target_bus)
		return
		
	# 1. Sample the curve drawn by the designer (returns 0.0 to 1.0)
	var curve_modifier: float = 1.0
	if mapping.translation_curve:
		curve_modifier = mapping.translation_curve.sample(raw_value)
	else:
		curve_modifier = raw_value
		
	# 2. Interpolate between the min and max output boundaries set by the designer
	var final_audio_value = lerp(mapping.min_output_value, mapping.max_output_value, curve_modifier)
	
	# 3. Retrieve the specific effect object instance from the target bus
	var effect = AudioServer.get_bus_effect(bus_idx, mapping.effect_index)
	if effect:
		# Dynamic property assignment (equivalent to effect.cutoff_hz = value)
		effect.set(mapping.effect_property, final_audio_value)
