extends Control

@export var drag_strength = 15.0
@export var return_speed = 8.0
@export var max_offset = 100.0

@export var anim_offset = Vector2.ZERO

@export var bob_freq = 1.6
@export var bob_amp = 1
@export var bob_side_amp = 1

var base_position = Vector2.ZERO

var drag_offset = Vector2.ZERO
var last_rot = Vector2.ZERO

var t = 0.0
var bob_offset = Vector2.ZERO

func _ready():
	base_position = position
	
	var cam = get_viewport().get_camera_3d()
	if cam:
		last_rot = Vector2(cam.global_rotation.x, cam.global_rotation.y)

func _process(delta):
	var cam = get_viewport().get_camera_3d()
	if cam == null:
		return

	var rot = Vector2(cam.global_rotation.x, cam.global_rotation.y)
	
	var delta_rot = Vector2(
		wrapf(rot.x - last_rot.x, -PI, PI),
		wrapf(rot.y - last_rot.y, -PI, PI)
	)
	last_rot = rot
	
	drag_offset += Vector2(
		delta_rot.y,
		delta_rot.x
	) * drag_strength
	
	drag_offset = drag_offset.lerp(Vector2.ZERO, delta * return_speed)
	drag_offset = drag_offset.clamp(Vector2(-max_offset, -max_offset), Vector2(max_offset, max_offset))
	
	
	var player = get_parent()
	
	if player and "velocity" in player:
		var vel = player.velocity
		vel.y = 0
		var speed = vel.length()
		
		if speed > 0.1:
			t += delta * speed
			
			bob_offset = Vector2(
				cos(t * bob_freq * 0.5) * bob_side_amp,
				sin(t * bob_freq) * bob_amp
			)
		else:
			bob_offset = bob_offset.lerp(Vector2.ZERO, delta * 8.0)
	
	position = base_position + drag_offset + bob_offset + anim_offset
