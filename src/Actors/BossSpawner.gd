extends Spawner

export var skip_intro := false

func setup_custom_variables() -> void:
	for key in custom_vars.keys():
		Log(name+ ": Setting property '" +key + "' to '"+ str(custom_vars[key]) + "' in " + spawned_object.name)
		spawned_object.set(key,custom_vars[key])
	if skip_intro:
		Log("Setting up Skip Intro for " + spawned_object.name)
		spawned_object.get_node("Intro").skip_intro = true
