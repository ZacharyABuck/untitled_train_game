extends PanelContainer
class_name BuffPanel

@export var buff: String

var value

@onready var label = $HBoxContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "[center]" + label.text + ": " + str(value) + "[/center]"
