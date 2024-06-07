extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	CurrentRun.world.current_world_info.world_map_player = self

