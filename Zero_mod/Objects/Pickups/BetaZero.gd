extends Node2D

export  var reset_armor: bool = false
export  var delete_when_collected: bool = true
export  var collectible_name: String = ""

onready var collisionShape: = $area2D / collisionShape2D
onready var capsule: = $Capsule
onready var armor_head: AnimatedSprite = $Head
onready var armor_body: AnimatedSprite = $Body
onready var armor_foot: AnimatedSprite = $Foot
onready var head_start_y: float = armor_head.position.y
onready var body_start_y: float = armor_body.position.y
onready var foot_start_y: float = armor_foot.position.y

var time_offset: float = 0.0
var amplitude: float = 1.0
var speed: float = 1.0
var timer: float = 0.0
var executing: bool = false
var glitch_timer: float = 0.0
var glitch_time: float = 1.0
var glitch_time_base: float = 1.0
var glitched: bool = false

func _ready() -> void :
	if reset_armor:
		call_deferred("lock_black_zero_armor")
		Savefile.save(Savefile.save_slot)
	Event.listen("player_set", self, "call_deferred_already_got")

func call_deferred_already_got() -> void :
	if delete_when_collected:
		call_deferred("handle_already_got")

func handle_already_got() -> void :
	if CharacterManager.betazero_unlocked:
		queue_free()

func handle_random_glitch(delta: float, sprite: AnimatedSprite) -> void :
	if glitched:
		sprite.offset.y = 0
		glitched = false
	else:
		sprite.offset.y = - 1
		
	glitch_timer += delta
	if glitch_timer >= glitch_time:
		glitch_timer = 0
		glitch_time = glitch_time_base * rand_range(0.5, 1.2)
		glitched = true
		var chance = randi() %100
		if chance < 100:
			var animation_name = sprite.animation
			if not animation_name.ends_with("_Glitch"):
				sprite.animation = animation_name + "_Glitch"
				if not sprite.is_connected("animation_finished", self, "_on_glitch_end"):
					sprite.connect("animation_finished", self, "_on_glitch_end", [sprite.animation, sprite])

func _on_glitch_end(anim_name: String, sprite: AnimatedSprite) -> void :
	if anim_name.ends_with("_Glitch"):
		var original_anim = anim_name.replace("_Glitch", "")
		sprite.animation = original_anim

func _physics_process(delta: float) -> void :
	handle_random_glitch(delta, armor_head)
	handle_random_glitch(delta, armor_body)
	handle_random_glitch(delta, armor_foot)
		
	if timer > 0:
		timer += delta
		if timer > 1.5:
			if not $audioStreamPlayer2D.playing:
				timer = 0
				GameManager.unpause(name)
				capsule.animation = "finished"
				queue_free()

func process_increase_health(_delta: float) -> void :
	pass

func _on_area2D_body_entered(body: Node) -> void :
	if not executing:
		if body.is_in_group("Player"):
			if body.get_parent().name == "Zero":
				unlock_black_zero_armor(body.get_parent())
				GameManager.pause(name)
				timer = 0.01
				$audioStreamPlayer2D2.play()
				executing = true
				armor_head.visible = false
				armor_body.visible = false
				armor_foot.visible = false
				collisionShape.disabled = true
				achievement_check()

func lock_black_zero_armor() -> void :
	CharacterManager.betazero_unlocked = false

func unlock_black_zero_armor(zero) -> void :
	CharacterManager.betazero_unlocked = true

func achievement_check() -> void :
	
	Savefile.save(Savefile.save_slot)
	CharacterManager._save()
