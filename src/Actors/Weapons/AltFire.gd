extends Shot
onready var buster: Node2D = $Buster
onready var icarus_buster: Node2D = get_node_or_null("Icarus Buster")

func switch_to_icarus():
	buster.active = false
	if icarus_buster != null:
		icarus_buster.active = true
		set_current_weapon(icarus_buster)
	
func switch_to_hermes():
	buster.active = true
	
	if icarus_buster != null:
		icarus_buster.active = false
		set_current_weapon(buster)
