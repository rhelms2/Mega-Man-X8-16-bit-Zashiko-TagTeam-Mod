extends Resource
class_name StageInfo

export  var save_flag: String
export  var beaten_condition: Array
export  var pointer_position: Vector2
export  var should_play_intro: bool = true
export  var name_id: String
export  var collectibles: Array
export  var preview: Texture
export  var sprite_frames: Resource
export  var animation_beats: Array
export  var inverse_sprites: bool = false


func get_name() -> String:
	return name_id + "_STAGE"

func get_boss() -> String:
	return name_id + "_NAME"

func get_load_name():
	return resource_path.get_file().trim_suffix(".tres")

func was_beaten() -> bool:
	if save_flag == "defeated":
		return true
	if GlobalVariables.exists(save_flag) and GlobalVariables.get(save_flag):
		return true
	return save_flag in GameManager.collectibles

func should_play_stage_intro() -> bool:
	if was_beaten():
		return false
	return should_play_intro

func can_be_played() -> bool:
	var beaten_stages: = 0
	var stages_to_beat: = beaten_condition.size()
	for stage in beaten_condition:
		if stage.was_beaten():
			beaten_stages += 1
	return beaten_stages >= stages_to_beat
