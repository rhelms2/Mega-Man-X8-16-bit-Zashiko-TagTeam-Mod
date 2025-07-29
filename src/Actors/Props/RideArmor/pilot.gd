extends AnimatedMirror

onready var reference_frames: Resource = preload("res://src/Actors/Props/RideArmor/pilot_sprites/ra_x.res")
onready var x_ride: Texture = preload("res://src/Actors/Props/RideArmor/pilot_sprites/ra_x.png")
onready var x_ultimate_ride: Texture = preload("res://X_mod/UltimateX/Sprites/ra_x_ultimate.png")
onready var zero_ride: Texture = preload("res://Zero_mod/X8/Sprites/Ride/ride_zero.png")
onready var axl_ride: Texture = preload("res://Axl_mod/Ride/ride_axl.png")


func set_player_sprite_sheet():
	var _texture = x_ride
	match CharacterManager.player_character:
		"Player":
			_texture = x_ride
		"X":
			_texture = x_ride
			if CharacterManager.ultimate_x_armor:
				_texture = x_ultimate_ride
		"Zero":
			
			_texture = zero_ride
		"Axl":
			_texture = axl_ride
	self.frames = CharacterManager.update_texture_with_new_size(_texture, reference_frames)

func _ready() -> void :
	set_player_sprite_sheet()
	material = GameManager.player.animatedSprite.material
