extends TileMap

onready var original_color = modulate
onready var map5: Node2D = get_node_or_null("../Stage Segments/_centralwhite_5")

func _ready() -> void:
	Event.listen("enemy_kill",self,"_on_enemy_death")
	Event.listen("pitch_black_energized",self,"queue_free")

func _on_enemy_death(enemy) -> void:
	if enemy is String and enemy == "boss":
		shine(self)
		if map5 != null:
			shine(map5)
	
func shine(target):
	var tween = create_tween()
	tween.tween_property(target,"modulate",Color(4,4,8,1),5)
	tween.tween_property(target,"modulate",Color(8,8,8,1),3)
	tween.tween_property(target,"modulate",Color(8,8,8,1),2)
	tween.tween_property(target,"modulate",original_color,1.7)
