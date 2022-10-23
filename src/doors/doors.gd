extends Spatial


export var show_handle := true


# Called when the node enters the scene tree for the first time.
func _ready():
	if(!show_handle):
		$Handle.hide()


func _on_Handle_turn_finished():
	$AudioStreamPlayer3D.play()
	$AnimationPlayer.play("open_doors")
