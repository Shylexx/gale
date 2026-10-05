extends Node

signal parameter_changed(param_name: String, new_value: float)

# TODO: Make it easier to register custom parameters, maybe like this?
# @export var Parameters: [Array]Parameter 

@export var parameters: Dictionary[String, float] = {
	"rain_intensity": 1.0,
}

func set_parameter(param_name: String, value: float) -> void:
	# clamp to resource max + min parameter
	value = clamp(value, 0.0, 1.0)
	parameters[param_name] = value
	parameter_changed.emit(param_name, value)
	
func get_parameter(param_name: String) -> float:
	return parameters.get(param_name)
