extends Label

export  var text_palette: Texture

onready var shadow: Label = $"../Shadow"
onready var tween: TweenController = TweenController.new(self, false)


func _ready() -> void :
	for child in get_parent().get_children():
		if child.has_signal("stage_selected"):
			child.connect("stage_selected", self, "on_stage_selected")
		else:
			child.connect("focus_entered", self, "clear")
	percent_visible = 0
	shadow.percent_visible = 0
	material.set_shader_param("palette", text_palette)

func clear() -> void :
	tween.reset()
	percent_visible = 0
	shadow.percent_visible = 0

func on_stage_selected(info: StageInfo) -> void :
	var boss_name = tr(info.get_boss())
	if info.beaten_condition.size() > 0:
		boss_name = "?????"
	text = tr("STAGE_DC") + ": \n    " + tr(info.get_name())
	text += "\n" + tr("BOSS_DC") + ": \n    " + boss_name
	if has_weapon(info):
		text += "\n" + tr("COMPLETION_DC") + ": \n    " + get_stage_completion_percentage(info) + "%"
	shadow.text = text
	clear()
	tween.create(Tween.EASE_IN_OUT, Tween.TRANS_LINEAR, true)
	tween.add_attribute("percent_visible", 1.0, 2.0)
	tween.add_attribute("percent_visible", 1.0, 2.0, shadow)

func get_stage_completion_percentage(info: StageInfo) -> String:
	var total_items: float = 0.0
	var collected_items: float = 0.0
	var total_collected_subtanks: float = 0.0
	for collected in GameManager.collectibles:
		if "subtank" in collected:
			total_collected_subtanks += 1
	for item in info.collectibles:
		var count_this: bool = true
		if CharacterManager.game_mode < 0 and ("black_zero_armor" in item or "white_axl_armor" in item):
			count_this = false
		if CharacterManager.game_mode == 1 and "subtank" in item and total_collected_subtanks >= 2:
			count_this = false
		elif CharacterManager.game_mode >= 2 and "subtank" in item:
			count_this = false
		elif CharacterManager.game_mode >= 3 and "life_up" in item:
			count_this = false
		if count_this:
			total_items += 1
			if item in GameManager.collectibles or GlobalVariables.exists(item):
				collected_items += 1
	if total_items == 0:
		total_items = 1
	return str(collected_items / total_items * 100).substr(0, 4)

func has_weapon(info: StageInfo) -> bool:
	for item in info.collectibles:
		if "finished_intro" in item:
			return item in GameManager.collectibles
		if "weapon" in item:
			return item in GameManager.collectibles
	return false
