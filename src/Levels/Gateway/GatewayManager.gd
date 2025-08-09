extends Node

var beaten_bosses: Array
var cleared_segments: Array


func _ready() -> void :
	Event.connect("gateway_reset_segment_cleared", self, "on_segments_reset")
	Event.connect("gateway_segment_cleared", self, "on_segment_cleared")
	if GlobalVariables.exists("gateway_segments_cleared"):
		cleared_segments = GlobalVariables.get("gateway_segments_cleared")
		
	Event.connect("gateway_boss_defeated", self, "on_boss_defeated")
	if GlobalVariables.exists("gateway_bosses_beaten"):
		beaten_bosses = GlobalVariables.get("gateway_bosses_beaten")

func on_segment_cleared(segment_name) -> void :
	if not segment_name in cleared_segments:
		cleared_segments.append(segment_name)
		GlobalVariables.set("gateway_segments_cleared", cleared_segments)

func is_segment_cleared(segment_name) -> bool:
	return segment_name in cleared_segments

func on_segments_reset() -> void :
	GlobalVariables.erase("gateway_segments_cleared")
	cleared_segments.clear()

func on_boss_defeated(boss_name) -> void :
	if not boss_name in beaten_bosses:
		beaten_bosses.append(boss_name)
		GlobalVariables.set("gateway_bosses_beaten", beaten_bosses)

func is_boss_defeated(boss_name) -> bool:
	return boss_name in beaten_bosses

func has_defeated_all_bosses() -> bool:
	return beaten_bosses.size() == 8

func has_defeated_copy_sigma() -> bool:
	if GlobalVariables.exists("copy_sigma_defeated"):
		return GlobalVariables.get("copy_sigma_defeated")
	return false

func soft_reset() -> void :
	GlobalVariables.erase("gateway_bosses_beaten")
	beaten_bosses.clear()

func reset_bosses() -> void :
	GlobalVariables.erase("gateway_bosses_beaten")
	GlobalVariables.erase("copy_sigma_defeated")
	beaten_bosses.clear()
