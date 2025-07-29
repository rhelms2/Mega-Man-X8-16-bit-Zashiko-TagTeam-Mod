extends LightGroup

var original_text: = "OPTIONS_ABV"

func on_focused_node(focus_node) -> void :
	nodes[0].text = tr(focus_node.name)

func on_no_focus() -> void :
	nodes[0].text = tr(original_text)
