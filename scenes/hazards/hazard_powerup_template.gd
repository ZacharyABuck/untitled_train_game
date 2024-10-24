extends Hazard
class_name Powerup

@export var gadget_detector: Area2D
@export var player_detector: Area2D
@export var collision: CollisionShape2D
@export var sprite: Node2D
var gadget_searcher: Area2D

var equipped_gadget
var target_gadget
var active_buffs: Dictionary

var powerup_time: float = 5.0

func _ready():
	gadget_detector.area_entered.connect(area_entered)
	player_detector.body_entered.connect(body_entered)
	
	instantiate_gadget_searcher()

func _physics_process(delta):
	super(delta)
	
	if equipped_gadget != null:
		global_position = equipped_gadget.global_position
	elif target_gadget != null:
		linear_velocity = global_position.direction_to(target_gadget.global_position)
		speed = clamp(speed + acceleration, 0, max_speed)
		move_and_collide(linear_velocity * speed * delta)

func instantiate_gadget_searcher():
	gadget_searcher = Area2D.new()
	add_child(gadget_searcher)
	var new_collision = CollisionShape2D.new()
	gadget_searcher.add_child(new_collision)
	new_collision.shape = CircleShape2D.new()
	new_collision.shape.radius = 300
	gadget_searcher.set_collision_mask_value(1, false)
	gadget_searcher.set_collision_mask_value(5, true)

func area_entered(area):
	if area.get_parent() is Gadget:
		equipped_gadget = area.get_parent()
		WeaponInfo.attach_buffs(active_buffs, area.get_parent().active_buffs)
		disable_collision()
		
		$Panel.hide()
		sprite.hide()
		
		#deactivate after 5 seconds
		await get_tree().create_timer(powerup_time).timeout
		WeaponInfo.detach_buffs(active_buffs, area.get_parent().active_buffs)
		queue_free()

func body_entered(body):
	if equipped_gadget == null:
		if body is Player:
			await get_tree().create_timer(.2).timeout
			if gadget_searcher.has_overlapping_areas():
				var closest_area = gadget_searcher.get_overlapping_areas()[0]
				for area in gadget_searcher.get_overlapping_areas():
					if global_position.distance_to(area.global_position) < global_position.distance_to(closest_area.global_position):
						closest_area = area
				target_gadget = closest_area.get_parent()
			else:
				queue_free()

func disable_collision():
	gadget_detector.get_child(0).set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
