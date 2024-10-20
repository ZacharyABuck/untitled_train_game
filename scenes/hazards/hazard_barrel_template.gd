extends Hazard
class_name Barrel

@export var damage = 10
@export var enemy_detector: Area2D
@export var explosion_area: Area2D
@export var sprite: Sprite2D
@export var explosion_sprite: AnimatedSprite2D

var active_buffs: Dictionary
var exploded: bool = false

func _ready():
	explosion_sprite.animation_finished.connect(animation_finished)
	enemy_detector.body_entered.connect(enemy_detector_body_entered)
	explosion_area.area_entered.connect(explosion_area_entered)

func _physics_process(delta):
	super(delta)
	
	if global_position.distance_to(CurrentRun.world.current_player_info.active_player.global_position) <= 100 and grabbed and !exploded:
		explode()

func enemy_detector_body_entered(body):
	if body is Enemy and grabbed and !exploded:
		explode()

func explode():
	exploded = true
	grabbed = false
	sprite.hide()
	explosion_sprite.play("hit")
	explosion_area.set_deferred("monitorable", true)
	explosion_area.monitoring = true
	AudioSystem.play_audio("explode", -15)

func explosion_area_entered(area):
	if area is HurtboxComponent:
		var new_hitbox : HurtboxComponent = area
		var attack = Attack.new()
		WeaponInfo.attach_buffs(active_buffs, attack.active_buffs)
		attack.attack_damage = damage
		new_hitbox.damage(attack, CurrentRun.world.current_player_info.active_player)

func animation_finished():
	if explosion_sprite.animation == "hit":
		queue_free()
