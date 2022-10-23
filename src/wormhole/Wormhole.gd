extends MeshInstance



# Called when the node enters the scene tree for the first time.
func _ready():
	disappear()


func disappear():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector3(0, 0, 0), 3).set_delay(5)
	tween.tween_callback(self, "queue_free")
