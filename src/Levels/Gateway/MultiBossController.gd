extends Node

onready var _reploids: = [$"../TrilobyteReploid", $"../PandaReploid", $"../YetiReploid", $"../AntonionReploid", $"../ManowarReploid", $"../RoosterReploid", $"../SunflowerReploid", $"../MantisReploid"]
onready var boss_watcher: Node2D = $"../BossWatcher"

var bosses_to_desperate: Array
var boss_ais: Dictionary
signal all_bosses_defeated

var total_bosses: = 0
var spawned_bosses: = 0
var current_boss_id: = 0

func _ready() -> void :
	for reploid in _reploids:
		reploid.connect("spawned_boss", self, "_on_boss_spawn")

func start_bossfight():
	Tools.timer(2, "bring_reploids", self)

func bring_reploids():
	total_bosses = 0
	spawned_bosses = 0
	boss_ais.clear()
	for reploid in _reploids:
		if is_instance_valid(reploid):
			for ready_boss in boss_watcher.crystals_ready:
				if ready_boss.capitalize() in reploid.name:
					reploid.start_battle()
					total_bosses += 1
	

func _on_boss_spawn(boss: Actor) -> void :
	
	boss.connect("zero_health", self, "on_boss_kill", [boss])
	bosses_to_desperate.append(boss)
	spawned_bosses += 1
	boss_ais[boss.name] = boss.get_node("BossAI")
	if total_bosses == spawned_bosses:
		Tools.timer(2, "decide_next_attack", self)

func decide_next_attack():
	
	var current_boss: = decide_next_ai()
	var next_interval: = decide_next_interval()
	if current_boss != null:
		if current_boss.active and current_boss.not_attacking():
			current_boss.execute_next_attack()
		else:
			next_interval = next_interval / 3
		
	if boss_ais.size() > 0:
		Tools.timer(next_interval, "decide_next_attack", self)

func decide_next_ai() -> BossAI:
	if boss_ais.size() <= 0:
		return null
	else:
		next_id()
		return boss_ais[boss_ais.keys()[current_boss_id]]

func next_id():
	current_boss_id += 1
	if current_boss_id > boss_ais.size() - 1:
		current_boss_id = 0
	

func decide_next_interval() -> float:
	match boss_ais.size():
		1:
			return 0.5
		2:
			return 1.3
		3:
			return 1.0
		4:
			return 0.75
		5:
			return 0.65
		6:
			return 0.55
		7:
			return 0.5
		8:
			return 0.45
	
	return 2.0

func on_boss_kill(dead_boss: Actor):
	
	bosses_to_desperate.erase(dead_boss)
	boss_ais.erase(dead_boss.name)
	if bosses_to_desperate.size() > 0:
		var smallest_hp_boss: Actor = bosses_to_desperate[0]
		var _hp: = 159.0
		for boss in bosses_to_desperate:
			
			if boss.current_health < smallest_hp_boss.current_health:
				smallest_hp_boss = boss
		queue_desperation(smallest_hp_boss)
	if boss_ais.size() == 0:
		
		Tools.timer(0.1, "emit_all_defeated", self)

func emit_all_defeated():
	emit_signal("all_bosses_defeated")
	if total_bosses == 8:
		Achievements.unlock("GATEWAYFIESTA")
	

func queue_desperation(boss: Actor):
	
	var ai = boss.get_node("BossAI")
	ai.desperation_threshold = 1
	bosses_to_desperate.erase(boss)
