extends Control

var current_credit_index = 0
var is_tween_hiding = false

func _ready():
	setup_credits()

func _on_ExitButton_pressed():
	get_tree().quit()

func roll_credits():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if(current_credit_index > $Credits.get_child_count() - 1):
		return
	$Tween.interpolate_property($Credits.get_children()[current_credit_index], "modulate", Color("#00ffffff"), Color("#ffffff"), 1, Tween.TRANS_LINEAR)
	$Tween.start()
	is_tween_hiding = false


func setup_credits():
	for credit in $Credits.get_children():
		credit.modulate = Color("00ffffff")


func _on_Tween_tween_completed(object, key):
	if(is_tween_hiding):
		current_credit_index += 1
		roll_credits()
	else:
		var current_credit = $Credits.get_children()[current_credit_index];
		yield(get_tree().create_timer(current_credit.seconds_displayed), "timeout")
		$Tween.interpolate_property(current_credit, "modulate", Color("#ffffff"), Color("#00ffffff"), 1, Tween.TRANS_LINEAR)
		$Tween.start()
		is_tween_hiding = true
