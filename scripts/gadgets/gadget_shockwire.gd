extends Node2D

var hard_point
var car

@onready var animations = $AnimatedSprite2D
@onready var hitbox = $HitBox
@onready var icon_sprite = $IconSprite

var damage = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	hard_point = get_parent()
	car = hard_point.car
	car.active_buffs.append("shock")

func _on_damage_timer_timeout():
	animations.play("shock_visible")
	damage_enemies()

func damage_enemies():
	for i in hitbox.get_overlapping_areas():
		var new_attack = Attack.new()
		new_attack.attack_damage = damage
		if i is HurtboxComponent and i.get_parent().is_in_group("enemy"):
			i.damage(new_attack)

func animation_finished():
	if animations.animation == "shock_visible":
		animations.play("default")
