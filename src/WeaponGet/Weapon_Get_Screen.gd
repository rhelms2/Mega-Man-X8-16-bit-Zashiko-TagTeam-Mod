extends Node2D

signal initialize
signal reset
signal start
signal flash
signal weapon_defined(weapon)


func _ready() -> void :
	Tools.timer(0.2, "initialize", self)

func initialize() -> void :
	emit_signal("initialize")
	reset()
	Tools.timer(6.5, "start", self, null, true)
	Tools.timer(8.2, "flash", self, null, true)

func reset() -> void :
	emit_signal("reset")

func start() -> void :
	emit_signal("start")

func flash() -> void :
	emit_signal("flash")
	GameManager.pause("weapon_get")

func _on_Armor_defined_weapon(weapon) -> void :
	emit_signal("weapon_defined", weapon)
