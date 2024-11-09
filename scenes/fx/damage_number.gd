extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, 2)
	await fade_tween.finished
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position -= Vector2(50,100)*delta
