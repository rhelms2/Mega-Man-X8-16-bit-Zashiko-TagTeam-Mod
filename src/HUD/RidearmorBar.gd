extends NinePatchRect

onready var hud: CanvasLayer = $".."
onready var texture_progress: TextureProgress = $textureProgress

func _ready() -> void:
	Event.listen("ridearmor_activate",self,"move_in")
	Event.listen("ridearmor_deactivate",self,"move_out")
	set_process(false)

func move_in() -> void:
	hud.tween_focus_on_bar(self,hud.player_bar,13,Color.gray)
	set_process(true)

func move_out() -> void:
	hud.tween_focus_on_bar(hud.player_bar,self,-14,Color.white)
	set_process(false)

func _process(_delta: float) -> void:
	if GameManager.player.ride:
		texture_progress.value = ceil(GameManager.player.ride.current_health)
