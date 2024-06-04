extends Edge

@onready var animations = $AnimatedSprite2D
@onready var target_range_area = $TargetRangeArea
@onready var melee_attack_component = $MeleeAttackComponent
@onready var attack_timer = $AttackTimer


var damage: float = 3
var target

func _ready():
	animations.modulate = Color.TRANSPARENT

func _physics_process(delta):
	if target == null:
		check_for_targets()
	else:
		melee_attack_component.DAMAGE = damage
		look_at(target.global_position)
		melee_attack_component.attack_if_target_in_range(target)

func handle_level_up():
	damage += 1
	update_player_info()

func update_player_info():
	pass

func animation_changed():
	match animations.animation:
		"windup":
			var fade_tween = create_tween()
			fade_tween.tween_property(animations, "modulate", Color.WHITE, .3)
		"strike":
			$AttackSFX.play()
		"recovery":
			var fade_tween = create_tween()
			fade_tween.tween_property(animations, "modulate", Color.TRANSPARENT, .3)

func check_for_targets():
	for i in target_range_area.get_overlapping_areas():
		if i.get_parent().is_in_group("enemy"):
			target = i.get_parent()
			break
	for i in target_range_area.get_overlapping_bodies():
		if i.get_parent().is_in_group("enemy"):
			target = i.get_parent()
			break
