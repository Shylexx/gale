@tool
extends EditorPlugin

const RTPC_AUTOLOAD = "RptcManager"
var audition_inspector_plugin

func _enable_plugin() -> void:
	add_autoload_singleton(RTPC_AUTOLOAD, "res://addons/gale/rtpc/rtpc_manager.tscn")
	
	audition_inspector_plugin = preload("res://addons/gale/audio_cue/editor/cue_audition_plugin.gd").new()
	add_inspector_plugin(audition_inspector_plugin)

func _disable_plugin() -> void:
	remove_autoload_singleton(RTPC_AUTOLOAD)
	
	ProjectSettings.set_setting("autoload/" + RTPC_AUTOLOAD, null)
	
	if audition_inspector_plugin:
		remove_inspector_plugin(audition_inspector_plugin)
