extends Edge

var shadow_time = 3.0
var shadow_upgrade_rate = 1.2
@onready var shadow_timer = $ShadowTimer
@onready var shadow = $Shadow
@onready var shadow_sfx = $ShadowSFX
var player_hurtbox: HurtboxComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	player_hurtbox = CurrentRun.world.current_player_info.active_player.hurtbox_component
	shadow_timer.wait_time = shadow_time

func handle_level_up():
	shadow_time *= shadow_upgrade_rate

func enable_shadow():
	shadow_sfx.play()
	player_hurtbox.process_mode = Node.PROCESS_MODE_DISABLED
	shadow.show()
	shadow_timer.wait_time = shadow_time
	shadow_timer.start()
	
func _on_shadow_timer_timeout():
	player_hurtbox.process_mode = Node.PROCESS_MODE_INHERIT
	shadow.hide()
	player_hurtbox.monitoring = true
