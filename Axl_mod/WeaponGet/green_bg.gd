extends Polygon2D


func _ready() -> void :
	pass


func _on_Armor_defined_weapon(weapon: WeaponResource) -> void :
	color = weapon.MainColor3
	pass
