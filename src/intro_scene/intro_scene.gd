extends Control

signal intro_scene_brane_finished

func _ready():
	$Timer.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("intro_scene_brane_finished")
	self.queue_free()



func _on_Timer_timeout():
	$AnimationPlayer.play("Opening")
