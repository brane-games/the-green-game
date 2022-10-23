tool
extends Spatial

export(float, 0,30) var grab_strength = 0 setget set_grab_strength, get_grab_strength

onready var TweenNode = $Tween

var _grabbedObject: Spatial
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_grab_strength(strength):
	if(get_node_or_null("pipa1") != null && get_node_or_null("pipa2") != null):
		$pipa1.rotation = Vector3($pipa1.rotation.x, deg2rad(strength), $pipa1.rotation.z)
		$pipa2.rotation = Vector3($pipa2.rotation.x,  deg2rad(-strength), $pipa2.rotation.z)
	grab_strength = strength


func get_grab_strength():
	return grab_strength


#tween.tween_property($Sprite, "modulate", Color.red, 1)
#tween.tween_property($Sprite, "scale", Vector2(), 1)
#tween.tween_callback($Sprite, "queue_free")

func grab(object: Spatial):
	_grabbedObject = object
	object.get_parent().remove_child(object)
	self.add_child(object)
	object.set_owner(self)
	# we have to make sure that the RigidBody inside the trash object is 0, 0, 0 in order for this to work
	object.get_child(0).translation = Vector3(0, 0, 0)
	object.global_translation = $GrabPosition3D.global_translation
	object.scale = Vector3(5, 5, 5)
	_rotate_object_into_grabber(object)
	_play_grab_sound(object.get_child(0))

func has_grabbed_object():
	return _grabbedObject != null


func throw(pos: Vector3):
	if(_grabbedObject && weakref(_grabbedObject).get_ref()):
		TweenNode.interpolate_property(_grabbedObject, "global_translation",
			_grabbedObject.global_translation, pos, 0.2,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
		TweenNode.start()


func _on_Tween_tween_completed(object, key):
	# if the tween completed is a throw then free the object
	if(key == ':global_translation'):
		_grabbedObject.queue_free()

func _rotate_object_into_grabber(object: Spatial):
	var ideal_rotation1 = Vector3(0.236533, 1.524114, -0.814752)
	var ideal_rotation2 = Vector3(0.236533, -1.624114, -0.814752)
	var distance1 = object.global_rotation.distance_squared_to(ideal_rotation1)
	var distance2 = object.global_rotation.distance_squared_to(ideal_rotation2)
	if(distance1 < distance2):
		object.rotation_degrees = Vector3(61, 20, 13)
	else:
		object.rotation_degrees = Vector3(-85, 46, -54)


func _play_grab_sound(object: Spatial):
	# if it's a plastic bag play plastic bag audio
	# if it's something else play something else
	$AudioStreamPlayer3D.play()

func make_green():
	var children = get_children()
	
	for child in children:
		if child is MeshInstance:
			var material = child.get_active_material(0)
			if(material):
				var tween = get_tree().create_tween()
				material.emission_enabled = true
				material.emission = Color("#72dd5c")
				material.emission_energy = 3
				tween.tween_property(material, "emission_energy", 0, 1)
