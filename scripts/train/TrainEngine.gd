# Similar to TrainVehicle but it applies power to its front bogie
class_name TrainEngine
extends TrainVehicle

signal train_info(stats: Dictionary)

@export var max_force := 1000.0
@export var gravity := 9.8
@export var friction_coefficient := 0.1
@export var rolling_resistance_coefficient := 0.005
@export var air_resistance_coefficient := 0.10
@export var air_density := 1.0
@export var velocity_multiplier := 1.5
@export var brake_power := 15.0
@export var brake_application_speed := 50.0

var friction_force := 0.0
@export var target_force_percent := 0.0
var applied_force := 0.0
var brake_force := 0.0
var velocity := 0.0

@onready var front_light = $Car/FrontLight
@onready var train_whistle_sfx = $TrainWhistleSFX



func _ready() -> void:
	TrainInfo.train_engine = self
	target_force_percent = TrainInfo.train_stats["speed"]
	super()
	_update_frictions()

# Update the friction forces that depend on mass when the towed mass changes
func change_towed_mass(mass_delta: float) -> void:
	super.change_towed_mass(mass_delta)
	_update_frictions()

func _process(delta: float) -> void:
	super(delta)
	if LevelInfo.active_level.world_light.energy >= .25 and front_light.enabled == false:
		front_light.enabled = true
		lights_on()
	if LevelInfo.active_level.world_light.energy <= .25 and front_light.enabled == true:
		front_light.enabled = false

func lights_on():
	$AnimationPlayer.play("lights_on")

# Apply forces
func _physics_process(delta: float) -> void:
	_updated_applied_force(delta)
	if velocity != 0 or applied_force != 0:
		_move_with_friction(delta)

# Move the front bogie by the applied force, minus friction forces
func _move_with_friction(delta: float) -> void:
	var resistance = friction_force + _drag_force()
	if applied_force == 0 && abs(velocity) < resistance / total_mass * delta:
		velocity = 0
	else:
		if velocity > 0:
			velocity = velocity + ((applied_force - resistance) / total_mass * delta)
		elif velocity < 0:
			velocity = velocity + ((applied_force + resistance) / total_mass * delta)
		else:
			velocity = velocity + (applied_force / total_mass * delta)
	_apply_brake(delta)
	front_bogie.move(velocity * velocity_multiplier * delta)

# Lerp the actual engine force from its current value to the throttle position
func _updated_applied_force(delta: float) -> void:
	applied_force = lerp(applied_force, max_force * target_force_percent, delta)
	if abs(applied_force) < 0.1: applied_force = 0

# Recalculate the velocity-independent friction forces for the current mass
func _update_frictions():
	friction_force = friction_coefficient * total_mass * gravity
	friction_force += rolling_resistance_coefficient * total_mass * gravity

# The air resistance force
func _drag_force():
	return (air_resistance_coefficient * air_density * (pow(velocity,2)/2))

# Reduce the velocity based on applied brake power
func _apply_brake(delta: float) -> void:
	if velocity == 0: return
	elif velocity > 0:
		velocity = max(velocity - brake_force * brake_power * delta, 0)
	elif velocity < 0:
		velocity = min(velocity + brake_force * brake_power * delta, 0)
