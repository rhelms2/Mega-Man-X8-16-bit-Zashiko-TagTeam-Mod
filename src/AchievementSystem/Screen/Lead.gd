extends Control
onready var unlocked: Label = $unlocked
onready var percentage: Label = $percentage
onready var progress_bar: ProgressBar = $progressBar

func _on_initialize() -> void:
	unlocked.text = get_count() + tr("ACHIEVEMENTSUNLOCKED")
	percentage.text = get_percentage()

func get_count() -> String:
	var total_achievements := Achievements.list.size()
	var unlocked_achievements := Achievements.get_unlocked_list().size()
	return str(unlocked_achievements) +"/" +str(total_achievements) + " "

func get_percentage() -> String:
	var total_achievements = float(Achievements.list.size())
	var unlocked_achievements = float(Achievements.get_unlocked_list().size())
	var _percentage = (unlocked_achievements / total_achievements) * 100
	progress_bar.value = _percentage
	return "(" + str(stepify(_percentage,0.1)) + "%)"
