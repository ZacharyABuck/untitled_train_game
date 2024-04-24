extends Edge
var edge_name = "Eldritch Grasp"
@onready var attack_timer = $MeleeAttackComponent/AttackTimer
@onready var animations = $TentacleAnimations
@onready var attack_component = $MeleeAttackComponent

var target


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = PlayerInfo.active_player.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = PlayerInfo.active_player.global_position
	if target is HurtboxComponent:
		look_at(target.global_position)
	if attack_component.target_is_in_range(target):
		attack_component.attack(target)

func handle_level_up():
	attack_component.damage += 5

func _on_melee_attack_component_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("tentacle hitbox detected")
	if area is HurtboxComponent:
		target = area
		print("tentacle target acquired: ", target)
