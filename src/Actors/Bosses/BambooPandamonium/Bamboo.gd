extends Node2D

var timer := 0.0

onready var collider: CollisionShape2D = $rigidBody2D/collisionShape2D
onready var animation := AnimationController.new($start)
onready var body1 := AnimationController.new($body1)
onready var body2 := AnimationController.new($body2)
onready var body3 := AnimationController.new($body3)
onready var all_parts = [body1,body2,body3]
onready var stage := AbilityStage.new(self,false)
onready var damage: Node2D = $DamageOnTouch
onready var pillar_damage: Node2D = $DamageOnTouch2

var expiring := false

signal solidified
signal expire

func Log(_d) -> void:
	pass

func _ready() -> void:
	animation.play("intro")
	damage.activate()
	pillar_damage.deactivate()
	Tools.timer(0.1,"kill_if_not_onscreen",self)

func kill_if_not_onscreen():
	if not GameManager.precise_is_on_screen(global_position):
		queue_free()

func _physics_process(delta: float) -> void:
	timer += delta
	if stage.is_initial() and animation.has_finished_last():
		animation.play("idle")
		stage.next()

	elif stage.currently_is(1) and timer > 0.7:
		animation.play("grow")
		emit_signal("solidified")
		stage.next()

	elif stage.currently_is(2) and animation.has_finished("grow"):
		pillar_damage.activate()
		damage.deactivate()
		scale_collider()
		animation.play("base_end")
		for part in all_parts:
			part.set_visible(true)
			part.play("end")
		stage.next()
	
	elif stage.currently_is(3) and animation.has_finished_last():
		pillar_damage.deactivate()

func _on_Health_zero_health() -> void:
	for part in all_parts:
		part.set_visible(false)
	animation.set_visible(false)
	pillar_damage.deactivate()
	damage.deactivate()
	collider.call_deferred("set_disabled",true)
	Tools.timer(2,"queue_free",self)
	stage.go_to_stage(3)

func expire() -> void:
	if not expiring:
		Tools.timer(0.05,"emit_expire",self)
		expiring = true

func emit_expire() -> void:
	emit_signal("expire")

func scale_collider() -> void:
	collider.disabled = false
	collider.scale.x = 0
	Tools.tween(collider,"scale",Vector2.ONE,0.16)
