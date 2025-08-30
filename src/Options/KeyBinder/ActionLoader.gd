extends VBoxContainer

export (PackedScene) var input_holder

onready var main: CanvasLayer = $"../../.."
onready var exit: TextureButton = $"../../exit"

var configurable = {
	"move_left": tr("LEFT_ACT"), 
	"move_right": "RIGHT_ACT", 
	"move_up": "UP_ACT", 
	"move_down": "DOWN_ACT", 
	"fire": "SHOT_ACT", 
	"alt_fire": "SHOT2_ACT", 
	"jump": "JUMP_ACT", 
	"dash": "DASH_ACT",
	"char_switch": "Change Player",  
	"select_special": "ARMORABILITY_ACT", 
	"weapon_select_left": "PREV_ACT", 
	"weapon_select_right": "NEXT_ACT",
	"reset_weapon": "WPNRESET_ACT", 
	
	"analog_left": "WPNLEFT_ACT", 
	"analog_right": "WPNRIGHT_ACT", 
	"analog_up": "WPNUP_ACT", 
	"analog_down": "WPNDOWN_ACT", 
	
	"pause": "PAUSE_ACT", 
	"ui_accept": "CONFIRM_ACT", 
	"ui_cancel": "CANCEL_ACT", 
}


func _ready() -> void :
	Setup_actions()

func Setup_actions() -> void :
	var last_child
	for action in configurable.keys():
		last_child = instantiate(action)
	Set_neighbours(last_child)

func instantiate(action) -> Node:
	var instance = input_holder.instance()
	add_child(instance, true)
	instance.setup(action, configurable[action], main)
	return instance

func Set_neighbours(last_child) -> void :
	exit.focus_neighbour_top = last_child.get_child(0).get_path()
	exit.focus_neighbour_bottom = get_child(0).get_child(0).get_path()
	get_child(0).get_child(0).focus_neighbour_top = exit.get_path()
	get_child(0).get_child(1).focus_neighbour_top = exit.get_path()
	last_child.get_child(0).focus_neighbour_bottom = exit.get_path()
	last_child.get_child(1).focus_neighbour_bottom = exit.get_path()
