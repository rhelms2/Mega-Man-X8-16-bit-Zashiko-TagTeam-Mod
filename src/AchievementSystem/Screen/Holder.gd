extends Control
onready var date: Label = $date
onready var icon: TextureRect = $icon
onready var title: Label = $title
onready var descripton: Label = $descripton


func _ready() -> void:
	pass

func initialize(achievement : Achievement) -> void:
	icon.material.set_shader_param("grayscale",true)
	icon.texture = achievement.icon
	title.text = achievement.get_title()
	descripton.text = achievement.get_description()
	
	if achievement.unlocked:
		icon.material.set_shader_param("grayscale",false)
		date.text = achievement.date
