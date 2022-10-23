extends KinematicBody

export var gravity_multiplier := 3.0
export var speed := 3.5
export var acceleration := 6
export var deceleration := 8
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 5
var direction := Vector3()
var input_axis := Vector2()
var velocity := Vector3()
var snap := Vector3()
var up_direction := Vector3.UP
var stop_on_slope := true
var _is_locked := false
onready var floor_max_angle: float = deg2rad(45.0)
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)
var _movement_disabled := false

func _ready():
	add_to_group("player")
	call_deferred('connect_to_handle_signals')

# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
	if(_is_locked || _movement_disabled):
		input_axis = Vector2(0, 0)
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		if Input.is_action_just_pressed("ui_select"):
			snap = Vector3.ZERO
			velocity.y = jump_height
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	accelerate(delta)
	
	velocity = move_and_slide_with_snap(velocity, snap, up_direction, 
			stop_on_slope, 4, floor_max_angle) #, false)

	if Input.is_action_just_pressed("act"):
		if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			$Head.grab()


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z

func _on_Handle_turn_finished():
	_is_locked = false
	$Head.unlock()

func connect_to_handle_signals():
	var handles = get_tree().get_nodes_in_group("handle")
	for handle in handles:
		handle.connect("turn_finished", self, "_on_Handle_turn_finished")

func disable_movement():
	_movement_disabled = true
	$CollisionShape.disabled = true
	$Head/grabber.hide()
	if($Head/garbage_bag):
		$Head/garbage_bag.hide()

func hide_grabber_and_disable_movement():
	_movement_disabled = true
	if($Head/garbage_bag):
		$Head/garbage_bag.hide()
	$Head/grabber.hide()

func show_grabber_and_enable_movement():
	_movement_disabled = false
#	$Head/garbage_bag.show()
	$Head.introduce_grabber()
	
func display_garbage_bag():
	pass
