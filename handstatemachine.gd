extends Node

@export var initial_state : State
@export var current_state : State
@export var locked = false
var currentfruitmesh : ArrayMesh
@onready var anims = $"../Anims/R_AnimationTree"

@onready var leftarm = $"../Neck/CameraBobber/leftarm/metarig/Skeleton3D/Cube_001"
@onready var rightarm = $"../Neck/CameraBobber/rightarm/metarig/Skeleton3D/Cube_001"

@export var normalalbedo : Color = Color(0.0, 0.0, 0.0, 0.0)



var states : Dictionary = {}
var currentfruit = ""
func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
	#anims.connect("animation_finished", )
	eventbus.Transistioned.connect(on_child_transistion)
	eventbus.grantitem.connect(grantitem)

	if initial_state:
		initial_state.Enter()
		current_state = initial_state

	
func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transistion(state, new_state_name):
	if state != current_state:
		return
	if locked:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.Exit()

	new_state.Enter()
	current_state = new_state

func grantitem(fruitname):
	if currentfruit == "":
		currentfruit = fruitname
		eventbus.Transistioned.emit(current_state, currentfruit)
		#print(currentfruit)
