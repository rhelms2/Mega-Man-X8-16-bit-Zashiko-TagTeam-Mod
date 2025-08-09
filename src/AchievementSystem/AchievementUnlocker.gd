extends Node

export  var achievement: Resource

func fire_achievement() -> void :
	
	Achievements.unlock(achievement.get_id())
