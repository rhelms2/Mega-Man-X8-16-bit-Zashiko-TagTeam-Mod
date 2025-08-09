extends Node
class_name BossAbilityZeroX8

export  var active: = false
export  var can_buffer: = true
export  var weapon: Resource
export  var current_ammo: = 28.0
const max_ammo: = 28.0
onready var character: Character = get_parent().get_parent()
onready var animatedSprite = character.get_node("animatedSprite")
onready var saber: = character.get_node("SaberCombo")
onready var saberdash: = character.get_node("SaberDash")
onready var saberjump: = character.get_node("SaberJump")
onready var saberwall: = character.get_node("SaberWall")
onready var saberjuuhazan: = character.get_node("Juuhazan")
onready var saberrasetsusen: = character.get_node("Rasetsusen")
onready var saberraikousen: = character.get_node("Raikousen")
onready var saberyoudantotsu: = character.get_node("Youdantotsu")
onready var saberhyouryuushou: = character.get_node("Hyouryuushou")
onready var saberenkoujin: = character.get_node("Enkoujin")


func _ready():
	call_deferred("set_ability")

func set_ability():
	if active:
		saber.deflectable = true
		saberdash.deflectable = true
		saberjump.deflectable = true
		saberwall.deflectable = true
		set_saber_colors(animatedSprite)

func set_saber_colors(node) -> void :
	if node != null:
		node.material.set_shader_param("R_SaberColor1", Color("#ffffff"))
		node.material.set_shader_param("R_SaberColor2", Color("#ffffff"))
		node.material.set_shader_param("R_SaberColor3", Color("#ffffff"))
		node.material.set_shader_param("R_SaberColor4", Color("#ffffff"))



func should_unlock(collectible: String) -> bool:
	return collectible == weapon.collectible
