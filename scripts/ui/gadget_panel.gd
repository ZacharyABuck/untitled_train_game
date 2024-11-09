extends PanelContainer

var gadget: String
@onready var gadget_name = $MarginContainer/VBoxContainer/GadgetName
@onready var gadget_icon = $MarginContainer/VBoxContainer/HBoxContainer/GadgetIcon
@onready var gadget_details = $MarginContainer/VBoxContainer/HBoxContainer/GadgetDetails
@onready var vbox = $MarginContainer/VBoxContainer
@onready var sell_container = $SellContainer
@onready var sell_button = $SellContainer/VBoxContainer/SellButton

var damage: float
var range: float
var attack_delay: float
var deployed: bool = false

var buffs: Dictionary

signal clicked
signal sold

func _ready():
	populate()
	calculate_random_buffs()

func populate():
	gadget_name.text = "[center]" + GadgetInfo.gadget_roster[gadget]["name"] + "[/center]"
	gadget_icon.texture = GadgetInfo.gadget_roster[gadget]["sprite"]
	
	var scene: Gadget = GadgetInfo.gadget_roster[gadget]["scene"].instantiate()
	scene.set_process(false)
	call_deferred("add_child", scene)
	
	await scene.ready
	
	var gun: ProjectileAttackComponent = scene.gun
	damage = gun.DAMAGE_PER_BULLET
	range = gun.TARGET_AREA.shape.radius
	attack_delay = gun.ATTACK_TIMER.wait_time
	
	gadget_details.text = "Damage: " + str(damage) + "\n" + \
							"Range: " + str(round(range*.1)) + "\n" + \
							"Cooldown: " + str(attack_delay) + "s"
	
	scene.queue_free()

func calculate_random_buffs():
	var rng = randi_range(1,10)
	var amount: int
	
	if rng > 9: amount = 3 #Rare
	elif rng > 7: amount = 2 #Uncommon
	elif rng > 4: amount = 1 #Common
	
	for i in amount:
		var random_panel = find_random_buff_panel()
		var new_panel = random_panel.instantiate()
		new_panel.value = snappedf(randf_range(0.2, 1.0)*CurrentRun.world.current_level_info.difficulty, .1)
		buffs[i] = {"buff": new_panel.buff, "value": new_panel.value}
		vbox.add_child(new_panel)
	print(buffs)

func find_random_buff_panel():
	var random_buff = GadgetInfo.buffs.keys().pick_random()
	return GadgetInfo.buffs[random_buff]["panel"]

func _on_button_pressed():
	if !CurrentRun.world.current_gadget_info.gadget_inventory.has(self):
		AudioSystem.play_audio("big_select", -10)
		var scale_tween = create_tween()
		scale_tween.tween_property(self, "scale", scale*.95, 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		await scale_tween.finished
		
		clicked.emit(self)
	else:
		sell_button.text = "Sell: +$" + str(GadgetInfo.gadget_roster[gadget]["value"])
		sell_container.show()

func _on_sell_button_pressed():
	sold.emit(self)

func _on_back_button_pressed():
	sell_container.hide()
