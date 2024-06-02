extends Area2D
class_name MeleeAttackComponent

@export var TARGET_TYPES = {
	"player":false,
	"enemy":false,
	"character":false,
	"car":false,
	"terrain":false
}
@export var ATTACK_TIMER := Timer
@export var DAMAGE : float = 2.0
@export var MOBILE_ATTACK := false #<-- Not currently functional.
@export var TARGET_AREA : CollisionShape2D #<-- The area of the attack, both for targeting and damaging.
@export var ANIMATIONS : AnimatedSprite2D #<-- needs "windup", "strike", and "recovery" animations.

var attack_timer
var damage
var attacker
var type
var target_types
var mobile_attack
var attack_target
var animations
var target_area
var targeted_areas

func _ready():
	attack_timer = ATTACK_TIMER
	damage = DAMAGE
	attacker = get_parent()
	target_types = TARGET_TYPES
	mobile_attack = MOBILE_ATTACK
	_set_layers(self)
	_connect_signals()

func attack_if_target_in_range(target):
	attack_target = target
	if target_is_in_range(attack_target):
		attack(attack_target)
	else:
		owner.state = "moving"

# This method performs an initial attack if there's no Timer running.
# This is generally only called internally, as it does not validate that a target is in range.
func attack(target):
	attack_target = target
	if attack_timer.is_stopped():
		animations.play("windup")
		attack_timer.start()

func _on_attack_timer_timeout():
	# we re-validate that the target is still in range.
	attack_timer.stop()
	attack_if_target_in_range(attack_target)

# This checks if the target overlaps with the attack area.
# Checks both Bodies and Areas, in case a Character is configured either way.
func target_is_in_range(target):
	attack_target = target
	var target_in_range = false
	for i in get_overlapping_bodies():
		if i == attack_target:
			target_in_range = true
			break
	if !target_in_range:
		for i in get_overlapping_areas():
			if i == attack_target:
				target_in_range = true
				break
	return target_in_range

# This is a separate function because a Melee Attack may cleave.
# This will result in the attack striking all Hurtboxes in its area.
func _get_overlapping_hurtboxes():
	var areas = []
	for overlapping_area in get_overlapping_areas():
		if overlapping_area is HurtboxComponent:
			areas.append(overlapping_area)
	return areas

func _on_animated_sprite_2d_animation_finished():
	# "windup"
	# "strike"
	# "recovery"
	if animations.animation == "windup":
		animations.play("strike")
		var hurtboxes = _get_overlapping_hurtboxes()
		for area in hurtboxes:
			var hurtbox : HurtboxComponent = area
			var new_attack = Attack.new()
			new_attack.attack_damage = damage
			hurtbox.damage(new_attack)
	if animations.animation == "strike":
		attack_timer.start()
		animations.play("recovery")

func _connect_signals():
	animations = ANIMATIONS
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	animations.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _set_layers(obj):
	if target_types["enemy"]:
		obj.set_collision_mask_value(4, true)
	if target_types["player"]:
		obj.set_collision_mask_value(1, true)
	if target_types["character"]:
		obj.set_collision_mask_value(10, true)
	if target_types["car"]:
		obj.set_collision_mask_value(3, true)
	if target_types["terrain"]:
		# Add in collission mask for terrain if needed.
		pass
