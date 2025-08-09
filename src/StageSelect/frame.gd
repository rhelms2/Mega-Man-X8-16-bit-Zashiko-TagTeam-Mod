extends Sprite

const frame_0 = preload("res://src/StageSelect/menu_0.png")

const frames: = [
	preload("res://src/StageSelect/menu_0.png"), 
	preload("res://src/StageSelect/menu_1.png"), 
	preload("res://src/StageSelect/menu_2.png"), 
	preload("res://src/StageSelect/menu_3.png")
]


func switch(key):
	texture = frames[key]
