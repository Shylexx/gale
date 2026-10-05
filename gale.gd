@tool
extends EditorPlugin

const RTPC_AUTOLOAD = "RTPCManager"

func _enable_plugin() -> void:
	add_autoload_singleton(RTPC_AUTOLOAD, "res://addons/gale/rtpc/rtpc_manager.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton(RTPC_AUTOLOAD)


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
