extends BossAI

const rays: int = 0
const dive: int = 1
const blast: int = 2
const tackle: int = 3


func guarantee_all_attacks_on_start() -> void :
	order_of_attacks = [
	rays, dive, tackle, blast, blast, dive, 
	rays, dive, blast, tackle, tackle, blast, 
	rays, blast, tackle, dive, dive, tackle, 
	rays, tackle, dive, blast, blast, dive, 
	rays, dive, blast, tackle, tackle, blast, 
	rays, blast, tackle, dive, dive, tackle, 
	rays, tackle, dive, blast, blast, dive, 
	rays, dive, blast, tackle, tackle, blast, 
	rays, blast, tackle, dive, dive, tackle, 
	rays, tackle, dive, blast, blast, dive, 
	rays, dive, blast, tackle, tackle, blast, 
	rays, blast, tackle, dive, dive, tackle, 
	rays, tackle, dive, blast, blast, dive, 
	rays, tackle, tackle, blast, 
	rays, blast, blast, dive]
