extends multistate
@onready var player = get_tree().get_first_node_in_group("player")
@onready var dashing = $"../dashing"
@onready var camera = %Camera3D
var t
var diminishingfactor = 0.0
var duration = 1.0
var wasdashingonfloor : bool
var dashadd = 15
var playerdz
var playerdx
var longjumpdirection : Vector3
var inputdir : Vector2
var cameradirZ
var cameradirX
func Enable():
	inputdir = player.input_dir 
	playerdx = player.direction.x
	playerdz = player.direction.z
	if dashing.isactive:
		
		dashing.frames += 10
		diminishingfactor = 2
		if player.dashcharges >= 1:
			wasdashingonfloor = true
		#	player.dashcharges -= 1
		t = 0.0

	
func Physics_Update(delta: float):
	
	cameradirZ = camera.global_transform.basis.z.normalized()
	cameradirX = camera.global_transform.basis.x.normalized()
	longjumpdirection = (cameradirX * inputdir.x + cameradirZ * inputdir.y).normalized()
		
	if player.is_on_floor():
		eventbus.switch_activity.emit(self, "disable")
	if wasdashingonfloor == true:
		player.velocity.z = 18 * diminishingfactor * longjumpdirection.z 
		player.velocity.x = 18 * diminishingfactor * longjumpdirection.x
		t = min(t + delta * duration, 1.0)
		diminishingfactor = lerp(1.8, 1.25, t)
		
		
	elif wasdashingonfloor != true and dashing.isactive:
		player.velocity.z += dashadd * playerdz
		player.velocity.x += dashadd * playerdx
	
func Disable():
	t = 0.0
	diminishingfactor = 1
	wasdashingonfloor = false
	
