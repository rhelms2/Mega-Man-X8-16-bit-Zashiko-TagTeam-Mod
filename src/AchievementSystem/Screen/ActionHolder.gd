extends VBoxContainer
const holder = preload("res://src/AchievementSystem/AchievementHolder.tscn")

onready var exit: TextureButton = $"../../exit"


func _on_initialize() -> void:
	for child in get_children():
		child.queue_free()
	
	for achievement in Achievements.get_unlocked_list():
		var h = holder.instance()
		add_child(h)
		h.initialize(achievement)
		
	for achievement in Achievements.get_locked_list():
		var h = holder.instance()
		add_child(h)
		h.initialize(achievement)

