extends PanelContainer

@onready var name_label = $MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel
@onready var type_label = $MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel2
@onready var sprite = $MarginContainer/HBoxContainer/TextureRect
@onready var close_sprite = $CloseSprite
@onready var button = $Button

var merc_name: String
var merc_type: String
var held: bool = false

func populate(new_merc):
	merc_name = new_merc
	
	name_label.text = "[center]" + merc_name + "[/center]"
	
	merc_type = CurrentRun.world.current_character_info.mercs_inventory[merc_name]["type"]
	type_label.text = "[center]" + merc_type + "[/center]"
	
	
	sprite.texture = CharacterInfo.mercs_roster[merc_type]["sprite"]

func _physics_process(_delta):
	pivot_offset = size*.5
	if held:
		global_position = Vector2(get_global_mouse_position().x - (size.x*.5), get_global_mouse_position().y - 50)

func preview(panel):
	AudioSystem.play_audio("quick_woosh", -15)
	var pos_tween = create_tween()
	pos_tween.tween_property(self, "global_position", (panel.mouse_detector.global_position + panel.mouse_detector.size*.5) - size*.5, .1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func place(panel):
	CurrentRun.world.current_train_info.cars_inventory[panel.car_number]["merc"] = merc_name
	AudioSystem.play_audio("big_ding", -15)
	panel.equipped_merc_panel = self
	held = false
	reparent(panel.mouse_detector)

func _on_button_mouse_entered():
	if get_parent() is Panel and close_sprite.visible == false:
		close_sprite.show()

func _on_button_mouse_exited():
	if get_parent() is Panel and close_sprite.visible == true:
		close_sprite.hide()
