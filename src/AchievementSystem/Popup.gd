class_name AchievementPopup extends CanvasLayer

onready var popup: Control = $popup
onready var show_position := popup.rect_position
onready var tween := TweenController.new(self,false)
onready var sound: AudioStreamPlayer = $achieve_sound
var queued_achievements : Array
const outscreen_position := 227.0

const title_limit := 28
const disc_limit := 48

onready var achievement_title: Label = $popup/title
onready var achievement_disc: Label = $popup/disc
onready var icon: TextureRect = $popup/icon
var showing := false
onready var save_icon: TextureRect = $save_icon

func _ready() -> void:
	popup.rect_position.y = outscreen_position

#func DEBUG_unlockall():
#	Achievements.reset_all()
#	for achievement in Achievements.list:
#		Achievements.unlock(achievement.get_id())

func show_achievement(achievement : Achievement):
	if Configurations.get("ShowAchievements"):
		queued_achievements.append(achievement)
		setup_next_achievement()

func setup_next_achievement():
	if queued_achievements.size() == 0:
		return
	
	if not showing:
		setup(queued_achievements[0])
		display()

func setup(achievement : Achievement):
	achievement_title.text = achievement.get_title()
	achievement_disc.text = achievement.get_description()
	
	var too_long = false
	while achievement_disc.get_line_count() >= 3:
		too_long = true
		achievement_disc.text = achievement_disc.text.substr(0,achievement_disc.text.length() -1)# + "..."
	if too_long:
		achievement_disc.text = achievement_disc.text.substr(0,achievement_disc.text.length() -3) + "..."
	
	icon.texture = achievement.icon
	queued_achievements.erase(achievement)
	handle_cheaters()

func handle_cheaters() -> void:
	if GameManager.is_cheating():
		achievement_title.text = tr("DEBUGACHIEVTITLE")
		#achievement_disc.text = tr("DEBUGACHIEVDISC")
	

func display() -> void:
	showing = true
	sound.play()
	tween.attribute("rect_position:y",show_position.y,0.5,popup)
	tween.add_wait(3.0)
	tween.add_attribute("rect_position:y",outscreen_position,0.5,popup)
	tween.add_callback("finished_displaying")

func finished_displaying():
	showing = false
	setup_next_achievement()

