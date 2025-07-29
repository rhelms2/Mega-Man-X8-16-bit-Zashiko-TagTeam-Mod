extends Control

export var _exit_focus : NodePath
onready var exit_focus := get_node(_exit_focus)
var boss_order : Array
var current_position := 1

onready var sunflower: Button = $"1"
onready var panda: Button = $"2"
onready var rooster: Button = $"3"
onready var manowar: Button = $"4"
onready var yeti: Button = $"5"
onready var mantis: Button = $"6"
onready var antonion: Button = $"7"
onready var trilobyte: Button = $"8"

var buttons : Array

func _ready() -> void:
	var i = 0
	for child in get_children():
		child.connect("pressed",self,"on_boss_press",[i,child])
		buttons.append(child)
		i += 1
	
	if GameManager.lumine_boss_order:
		display_set_boss_order()

func display_set_boss_order():
	var i = 0
	for boss_button in buttons:
		var label : Label = boss_button.get_child(0)
		label.text = str(GameManager.lumine_boss_order[i] + 1)
		#print(GameManager.lumine_boss_order[i] + 1)
		i += 1

func on_boss_press(boss_number : int, button : Button):
	var label : Label = button.get_child(0)
	button.grab_focus()
	if current_position == 1 or current_position > 8 or boss_number in boss_order:
		reset()
	
	button.pressed = true
	boss_order.append(boss_number)
	label.text = str(current_position)
	current_position += 1
	exit_focus.visible = true
	exit_focus.grab_focus()
	exit_focus.visible = false
	#print(boss_order)
	
	if boss_order.size() == 8:
		GameManager.lumine_boss_order = boss_order
		#print(boss_order)

func reset():
	boss_order.clear()
	current_position = 1
	for child in buttons:
		child.get_node("label").text = " "
		child.pressed = false


func _on_DebugAndCheats_cheat_pressed(visibility : bool) -> void:
	#visible = visibility
	pass # Replace with function body.
