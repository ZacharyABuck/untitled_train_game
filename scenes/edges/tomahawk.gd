extends Edge

@onready var hatchet = $Hatchet

func _ready():
	super()
	
	player.melee_attack_fired.connect(hatchet.shoot)

func handle_level_up():
	hatchet.scatter_shot_amount += 1
