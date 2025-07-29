extends Resource
class_name WeaponResource

export  var short_name: String
export  var collectible: String
export  var icon: Texture
export  var faded_icon: Texture
export  var palette: Texture
export  var regular_shot: PackedScene
export  var regular_ammo_cost: = 1.0
export  var charged_shot: PackedScene
export  var charged_ammo_cost: = 4.0
export  var cooldown: = 0.1
export  var sound: AudioStream
export  var charged_sound: AudioStream

export  var input_sequence: Resource

export  var MainColor1: Color
export  var MainColor2: Color
export  var MainColor3: Color
export  var MainColor4: Color
export  var MainColor5: Color
export  var MainColor6: Color
export  var hermes_palette: Texture
export  var icarus_palette: Texture

func get_charge_color() -> Color:
	return MainColor2
	
func get_palette() -> Array:
	return [MainColor1, MainColor2, MainColor3, MainColor4, MainColor5, MainColor6]
