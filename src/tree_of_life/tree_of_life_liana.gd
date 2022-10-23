extends Spatial

var _is_highlighted := false

onready var Grabber = $grabber
var _initial_grabber_transform

func _ready():
	pass


func change_outline_visibility(is_visible: bool):
	if(is_visible):
		_is_highlighted = true
		$StaticBody/SoftBody.get_active_material(0).emission = Color("#f9cb2d")
	else:
		_is_highlighted = false
		$StaticBody/SoftBody.get_active_material(0).emission = Color("#2df93b")


func start_grabbing_animation(grabber_transform):
	Grabber.show()
	Grabber.global_transform = grabber_transform

	_initial_grabber_transform = grabber_transform
	$Tween.interpolate_property(Grabber, "translation",
		Grabber.translation, Vector3(-0.179, 0.576, -0.296), 0.6,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property(Grabber, "rotation_degrees",
		Grabber.rotation_degrees, Vector3(49.85, 169.388, -119.57), 0.4,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

func get_is_highlighted():
	return _is_highlighted
