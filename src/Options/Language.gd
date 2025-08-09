extends X8OptionButton

var current_index := 0
onready var locales := TranslationServer.get_loaded_locales()
signal translation_updated


func setup() -> void:
	set_language(get_current_language())
	current_index = locales.find(get_current_language())

func increase_value() -> void: #override
	current_index += 1
	if current_index > locales.size() -1:
		current_index = 0
	set_language(locales[current_index])

func decrease_value() -> void: #override
	current_index -= 1
	if current_index < 0:
		current_index = locales.size() -1
	set_language(locales[current_index])

func set_language(locale : String):
	TranslationServer.set_locale(locale)
	Configurations.set("Language",TranslationServer.get_locale())
	display_value(Configurations.get("Language"))
	emit_signal("translation_updated")
	Event.emit_signal("translation_updated")

func display_value(new_value) -> void:
	if new_value == "pr":
		new_value = "huebr"
	if new_value == "ja_JP":
		new_value = "jp"
	value.text = tr(str(new_value))

func get_current_language():
	if Configurations.get("Language"):
		return Configurations.get("Language")
	
	if OS.get_locale_language() in locales:
		return OS.get_locale_language()
	
	else:
		return "en"

