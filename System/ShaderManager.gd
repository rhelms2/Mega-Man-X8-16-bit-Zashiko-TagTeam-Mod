extends Node


func set_global_shaders_enabled(enabled: bool) -> void :
	var nodes = get_tree().get_root().get_children()
	for node in nodes:
		disable_shaders_recursively(node, enabled)

func disable_shaders_recursively(node: Node, enabled: bool) -> void :
	if node is CanvasItem:
		var material = node.get("material")
		if material and material is ShaderMaterial:
			if not enabled:
				node.set("material", CanvasItemMaterial.new())
			else:
				node.set("material", material)

	for child in node.get_children():
		disable_shaders_recursively(child, enabled)
