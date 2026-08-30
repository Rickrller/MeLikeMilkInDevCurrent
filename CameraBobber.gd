extends Node3D
@export var bob_freq = 1.6
@export var bob_amp = 0.5
var t_bob = 0.0
var last_pos = Vector3.ZERO
@onready var player: CharacterBody3D = get_parent().get_parent()
@export var max_strafe_tilt_deg: float = 4.0
@export var max_turn_tilt_deg: float = 25.0
@export var turn_tilt_sensitivity: float = 3
@export var turn_speed_curve: float = 2.0
@export var turn_rate_smoothing: float = 10.0
@export var tilt_sensitivity: float = 10.0
@export var tilt_lerp_speed: float = 30.0
@export var air_tilt_lerp_speed: float = 6.0
@export var speed_rise_rate: float = 40.0
@export var speed_fall_rate: float = 15.0
var _last_yaw: float = 0.0
var _display_speed: float = 0.0
var _smoothed_turn_rate: float = 0.0
var _current_roll_rad: float = 0.0

func _process(delta):
	var actual_velocity = (player.global_transform.origin - last_pos) / delta
	last_pos = player.global_transform.origin
	var speed = Vector2(actual_velocity.x, actual_velocity.z).length()

	var target_offset = Vector3.ZERO
	if speed > 4 and player.is_on_floor():
		t_bob += delta * speed
		target_offset += Vector3(
			cos(t_bob * bob_freq * 0.5) * bob_amp,
			sin(t_bob * bob_freq) * bob_amp, 0)
	position = position.lerp(target_offset, delta * 10.0)

	var vel: Vector3 = player.velocity
	var raw_speed: float = vel.length()
	_display_speed = move_toward(_display_speed, raw_speed,
		(speed_rise_rate if raw_speed > _display_speed else speed_fall_rate) * delta)
	var local_velocity: Vector3 = player.global_transform.basis.inverse() * vel
	var strafe_ratio: float = clamp(local_velocity.x / tilt_sensitivity, -1.0, 1.0)
	var strafe_tilt: float = -strafe_ratio * max_strafe_tilt_deg
	var current_yaw: float = player.rotation.y
	var yaw_delta: float = wrapf(current_yaw - _last_yaw, -PI, PI)
	var raw_turn_rate: float = yaw_delta / delta
	_last_yaw = current_yaw
	_smoothed_turn_rate = lerp(_smoothed_turn_rate, raw_turn_rate, clamp(turn_rate_smoothing * delta, 0.0, 1.0))
	var speed_factor: float = _display_speed / (_display_speed + tilt_sensitivity)
	var turn_speed_factor: float = pow(speed_factor, turn_speed_curve)
	var turn_ratio: float = clamp(_smoothed_turn_rate / turn_tilt_sensitivity, -1.0, 1.0)
	var turn_tilt: float = turn_ratio * max_turn_tilt_deg * turn_speed_factor
	var target_tilt_rad: float = deg_to_rad(strafe_tilt + turn_tilt)
	var current_lerp_speed: float = tilt_lerp_speed if player.is_on_floor() else air_tilt_lerp_speed
	_current_roll_rad = lerp_angle(_current_roll_rad, target_tilt_rad, current_lerp_speed * delta)
	rotation_degrees.z = rad_to_deg(_current_roll_rad)
