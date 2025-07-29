extends Label

var abilities = []

func _ready() -> void :
	for child in get_parent().get_children():
		if child is NewAbility:
			abilities.append(child)

func _physics_process(_delta: float) -> void :
	var txt: = ""
	
	
	for ability in abilities:
		if ability.is_executing():
			txt += ability.name + ", "
		else:
			txt += " "
	text = txt
