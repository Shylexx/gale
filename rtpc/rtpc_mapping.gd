class_name RTPCMapping
extends Resource

@export var parameter_name: String
@export var target_bus: String = "Master"
@export var effect_index: int = 0
@export var effect_property: String = ""

@export var min_output_value: float = 100.0
@export var max_output_value: float = 200.0

@export var translation_curve: Curve = Curve.new()
