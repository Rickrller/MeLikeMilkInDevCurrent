extends Node
## ScreenShake.gd — Autoload singleton (3D version)
##
## RECOMMENDED SETUP (avoids fighting with camera bob/follow scripts):
##
##   Head (your bobbing/look script moves this, unchanged)
##    └── ShakeRig (empty Node3D — added by you, rest transform is always 0,0,0)
##         └── Camera3D (untouched by any script — just inherits both transforms)
##
## 1. Save this file as res://autoload/ScreenShake.gd
## 2. Project > Project Settings > Autoload > add this script, name it "ScreenShake"
## 3. Add an empty Node3D called "ShakeRig" as a child of whatever node your
##    bob/look script moves, and make Camera3D a child of ShakeRig.
## 4. In your scene's _ready(): ScreenShake.set_target($Head/ShakeRig)
## 5. Call from anywhere:
##      ScreenShake.shake_simple(0.2, 0.1)
##      ScreenShake.shake_trauma(0.5)
##      ScreenShake.shake_impulse(Vector3.LEFT, 0.3)
##
## Because ShakeRig's rest position/rotation is always (0,0,0), this script
## never needs to know what the bob script is doing, and there's no risk of
## the two overwriting each other or drifting out of sync.

# ---- Config ----
@export var max_offset: Vector3 = Vector3(0.3, 0.3, 0.0)   # local-space position clamp
@export var max_rotation: float = 0.05                       # radians
@export var trauma_decay: float = 1.2                         # trauma lost per second
@export var noise_speed: float = 25.0                         # how fast trauma-noise scrolls

var _target: Node3D = null
var _noise := FastNoiseLite.new()
var _noise_time: float = 0.0

# --- State for each shake type ---
var _simple_time_left: float = 0.0
var _simple_strength: float = 0.0
var _simple_duration: float = 0.0

var _trauma: float = 0.0   # 0..1

var _impulse_offset: Vector3 = Vector3.ZERO
var _impulse_velocity: Vector3 = Vector3.ZERO
var _impulse_stiffness: float = 120.0
var _impulse_damping: float = 8.0


func _ready() -> void:
	_noise.seed = randi()
	_noise.frequency = 0.5
	set_process(true)


## Point this at an empty Node3D (see setup notes above), NOT your camera or
## bob-controlled node, so shake never conflicts with other transform logic.
func set_target(node: Node3D) -> void:
	_target = node


## Call when leaving a scene (e.g. before switching to the menu) so a stale
## reference to a freed/irrelevant node can't linger.
func clear_target() -> void:
	_target = null


func _get_target() -> Node3D:
	# No automatic fallback on purpose: silently grabbing "whatever camera
	# is current" and forcing its transform to zero every frame will stomp
	# on scenes (menus, cutscenes) that never called set_target(). Every
	# scene that wants shake must opt in explicitly via set_target().
	if _target and is_instance_valid(_target):
		return _target
	return null


# ---------------- PUBLIC API ----------------

## Type 1: quick decaying random jitter
func shake_simple(duration: float, strength: float) -> void:
	_simple_duration = duration
	_simple_time_left = duration
	_simple_strength = strength


## Type 2: smooth noise-based shake, additive trauma (stacks nicely)
func shake_trauma(amount: float) -> void:
	_trauma = clamp(_trauma + amount, 0.0, 1.0)


## Type 3: directional "kick" that springs back to center
## direction is in the target's LOCAL space, e.g. Vector3.RIGHT, Vector3.UP
func shake_impulse(direction: Vector3, strength: float) -> void:
	_impulse_velocity += direction.normalized() * strength


# ---------------- PROCESS ----------------

func _process(delta: float) -> void:
	var target := _get_target()
	if target == null:
		return

	var pos_offset := Vector3.ZERO
	var rot_offset := Vector3.ZERO

	# --- Simple shake ---
	if _simple_time_left > 0.0:
		_simple_time_left -= delta
		var t: float = _simple_time_left / maxf(_simple_duration, 0.0001)
		var s: float = _simple_strength * t
		pos_offset += Vector3(randf_range(-s, s), randf_range(-s, s), 0.0)
		rot_offset.z += randf_range(-s, s) * 0.5

	# --- Trauma shake ---
	if _trauma > 0.0:
		_noise_time += delta * noise_speed
		var power: float = _trauma * _trauma
		var nx := _noise.get_noise_2d(_noise_time, 0.0)
		var ny := _noise.get_noise_2d(0.0, _noise_time)
		var nz := _noise.get_noise_2d(_noise_time, 100.0)
		var nrx := _noise.get_noise_2d(_noise_time, 200.0)
		var nry := _noise.get_noise_2d(_noise_time, 300.0)
		pos_offset += Vector3(nx, ny, nz) * max_offset * power
		rot_offset += Vector3(nrx, nry, 0.0) * max_rotation * power
		_trauma = maxf(_trauma - trauma_decay * delta, 0.0)

	# --- Impulse shake (spring-damper toward zero) ---
	var spring_force := -_impulse_offset * _impulse_stiffness
	var damping_force := -_impulse_velocity * _impulse_damping
	_impulse_velocity += (spring_force + damping_force) * delta
	_impulse_offset += _impulse_velocity * delta
	pos_offset += _impulse_offset

	# --- Apply directly as local transform (rig's rest is always zero) ---
	pos_offset.x = clamp(pos_offset.x, -max_offset.x, max_offset.x)
	pos_offset.y = clamp(pos_offset.y, -max_offset.y, max_offset.y)
	pos_offset.z = clamp(pos_offset.z, -max_offset.z, max_offset.z)
	target.position = pos_offset
	target.rotation = rot_offset
