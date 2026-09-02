extends RayCast3D
@onready var VFX = load("res://OrangeEyeBeam.tscn")
var damagemult
var dir
var pos
var count
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var VFXInstance = VFX.instantiate()
	var orangebeampoint = get_tree().get_first_node_in_group("OrangeBeamPoint")
	if is_instance_valid(orangebeampoint) and not VFXInstance == null:
		orangebeampoint.add_child(VFXInstance)
	count = 60
	if not damagemult:
		damagemult = 1
	
func _physics_process(_delta: float) -> void:
	if count > 0:
		global_position = get_parent().neck.global_position
		global_rotation = get_parent().neck.global_rotation
		#print("shot fired")
		
		force_raycast_update()
		if is_colliding():
			
			var hit = get_collider()
			if hit != null and hit.is_in_group("enemy") and not hit.is_in_group("fallentree"):
				hit.health -= 4 * damagemult
		count -= 1
	else:
		queue_free()
	
