extends Spatial


signal floor_door_opened


# Called when the node enters the scene tree for the first time.
func _ready():
	if($MeshInstance2):
		$MeshInstance2.hide()

func _on_Handle_turn_finished():
	$AnimationPlayer.play("open_doors")
	emit_signal("floor_door_opened")
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer3D.play()
