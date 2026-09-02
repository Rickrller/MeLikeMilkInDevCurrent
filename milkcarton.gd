extends Node3D

@export var bob_height: float = 0.25
@export var bob_speed: float = 2.0
@export var rotation_speed: float = 1.5

@export_group("Pulse")
@export var pulse_speed: float = 3.0
@export var pulse_energy_max: float = 6.0   # how strong the white glow gets at peak

var _start_y: float
var _time: float = 0.0
var _mesh: MeshInstance3D
var _material: StandardMaterial3D

func _ready() -> void:
	_start_y = position.y

	_mesh = _find_mesh_instance(self)
	if _mesh == null:
		push_warning("No MeshInstance3D found under " + name)
		return

	# Try surface override first, then fall back to the mesh resource's own material
	var existing_mat: Material = _mesh.get_surface_override_material(0)
	if existing_mat == null and _mesh.mesh != null:
		existing_mat = _mesh.mesh.surface_get_material(0)

	if existing_mat == null:
		push_warning("No existing material found on " + _mesh.name + " — texture will be lost if we create a new one.")
		return

	if existing_mat is StandardMaterial3D:
		_material = existing_mat.duplicate(true) as StandardMaterial3D
	else:
		push_warning(_mesh.name + " uses a non-StandardMaterial3D (e.g. ShaderMaterial) — this script won't work as-is. Let me know and I'll adapt it.")
		return

	# Don't touch albedo_color/albedo_texture — leave the original look intact
	_material.emission_enabled = true
	_material.emission = Color.WHITE
	_material.emission_energy_multiplier = 0.0

	_mesh.set_surface_override_material(0, _material)

func _process(delta: float) -> void:
	_time += delta

	position.y = _start_y + sin(_time * bob_speed) * bob_height
	rotate_y(rotation_speed * delta)

	if _material:
		var t: float = (sin(_time * pulse_speed) + 1.0) * 0.5  # 0..1
		_material.emission_energy_multiplier = t * pulse_energy_max
		_material.no_depth_test = t > 0.05   # only x-ray while glowing, optional

func _find_mesh_instance(node: Node) -> MeshInstance3D:
	for child in node.get_children():
		if child is MeshInstance3D:
			return child
		var found := _find_mesh_instance(child)
		if found != null:
			return found
	return null
