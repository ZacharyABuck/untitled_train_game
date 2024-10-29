extends PanelContainer

@onready var name_label = $VBoxContainer/NameLabel
@onready var description_label = $VBoxContainer/DescriptionLabel

var edge: String

func populate(new_edge):
	edge = new_edge
	name_label.text = "[center]" + EdgeInfo.edge_roster[new_edge]["name"] + "[/center]"
	description_label.text = "[center]" + EdgeInfo.edge_roster[new_edge]["description"] + "[/center]"
