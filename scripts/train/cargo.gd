extends Node2D

@onready var health_component = $HealthComponent
@onready var sprite = $Sprite2D

var mission

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health_component.health > health_component.MAX_HEALTH*.8:
		sprite.frame = 0
	elif health_component.health > health_component.MAX_HEALTH*.6:
		sprite.frame = 1
	elif health_component.health > health_component.MAX_HEALTH*.4:
		sprite.frame = 2
	elif health_component.health > health_component.MAX_HEALTH*.2:
		sprite.frame = 3
