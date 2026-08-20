extends Node

@export var initial_state : State
@export var current_state : State

@onready var fruitmesh = $"../Neck/arm"
var currentfruitmesh : ArrayMesh

const aloemesh = preload("res://meshes/aloemesh.tscn")
const carrotmesh = preload("res://meshes/carrotmesh.tscn")
const coconutmesh = preload("res://meshes/coconutmesh.tscn")
const grapemesh = preload("res://meshes/grapemesh.tscn")
const lemonmesh = preload("res://meshes/lemonmesh.tscn")
const orangemesh = preload("res://meshes/orangemesh.tscn")
const peartomesh = preload("res://meshes/peartomesh.tscn")
const starfruitmesh = preload("res://meshes/starfruitmesh.tscn")
const strawberrymesh = preload("res://meshes/strawberrymesh.tscn")


var states : Dictionary = {}
var currentfruit = ""
func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
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
