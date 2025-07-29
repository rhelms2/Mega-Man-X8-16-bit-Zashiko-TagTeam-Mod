extends Control
onready var sunflower_weapon: TextureButton = $sunflower_weapon
onready var antonion_weapon: TextureButton = $antonion_weapon
onready var mantis_weapon: TextureButton = $mantis_weapon
onready var manowar_weapon: TextureButton = $manowar_weapon
onready var panda_weapon: TextureButton = $panda_weapon
onready var trilobyte_weapon: TextureButton = $trilobyte_weapon
onready var yeti_weapon: TextureButton = $yeti_weapon
onready var rooster_weapon: TextureButton = $rooster_weapon

onready var pause: CanvasLayer = $"../.."

onready var abilities = [
	sunflower_weapon, 
	antonion_weapon, 
	mantis_weapon, 
	manowar_weapon, 
	panda_weapon, 
	trilobyte_weapon, 
	yeti_weapon, 
	rooster_weapon
]

func _ready() -> void :
	pause.connect("pause_starting", self, "show_parts")

func show_parts() -> void :
	for ability in abilities:
		ability.visible = ability.name in GameManager.collectibles
