extends Sprite

export  var weapon: Resource
onready var _select: AnimatedSprite = $"../select"
export  var selectable: = false
export  var already_selected: = false
<<<<<<< HEAD
=======


>>>>>>> source_private/main
func _ready() -> void :
	_on_hotswap_opened()
	get_parent().connect("weapon_selected", self, "on_select")
	get_parent().connect("unselected_all", self, "unselect")
<<<<<<< HEAD
=======
	Event.listen("refresh_hud", self, "_on_hotswap_opened")
>>>>>>> source_private/main

func _on_hotswap_opened() -> void :
	modulate.a = 0.5
	if weapon.collectible in GameManager.collectibles:
<<<<<<< HEAD
		make_selectable()
	else:
		deactivate()

=======
		if get_parent().character == GameManager.player:
			make_selectable()
		else:
			remove_icon()
	else:
		deactivate()

func remove_icon() -> void :
	selectable = false
	texture = null

>>>>>>> source_private/main
func deactivate() -> void :
	pass

func make_selectable() -> void :
	selectable = true
	texture = weapon.faded_icon
	pass

func on_select(sweapon) -> void :
	if selectable and sweapon != self:
		texture = weapon.faded_icon
		modulate.a = 0.5
		already_selected = false
		
func unselect() -> void :
	if selectable:
		texture = weapon.faded_icon
		modulate.a = 0.5
		already_selected = false
	if _select.visible:
		_select.visible = false
		


func select() -> void :
	texture = weapon.icon
	modulate.a = 1
	Event.emit_signal("select_weapon", weapon)
	_select.position = position
	_select.visible = true
	_select.frame = 0
	already_selected = true
