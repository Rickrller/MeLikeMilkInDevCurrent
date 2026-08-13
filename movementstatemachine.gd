extends Node

@export var initial_states : Array = []
var states : Dictionary = {}
var current_states : Array = []
func _ready():
	for child in get_children():
		if child is multistate:
			states[child.name] = child
			#child.reparent(Disabled)
			child.isactive = false
	eventbus.switch_activity.connect(on_child_switched)
	for state in initial_states:
		if state:
			var changestate
			changestate = get_node(state)
			#print(changestate)
			#print_tree_pretty()
			#changestate.reparent(Active)
			changestate.isactive = true
			current_states.append(changestate)
			changestate.Enable()
			#print_tree_pretty()
			

func _process(delta):
	for state in current_states:
		#var activestate = get_node(NodePath("Active/" + state))
		state.Update(delta)

func _physics_process(delta):
	for state in current_states:
		state.Physics_Update(delta)
func on_child_switched(state, new_activity):
	#print_tree_pretty()
	#print(state, new_activity)
	#if not state in current_states:
		#return
	
	var activity = new_activity.to_lower()
	if !state:
		return
		
	if activity == "active":
		#print(state)
		#print("tried to switch to active")
		var node = get_node(state)
		if state is String:
			state = node
		
		if state not in current_states:
			current_states.append(state)
			state.Enable()
			#state.reparent(Active)
			state.isactive = true
			
	elif activity == "disabled" or activity == "disable":
		#print("tried to switch to disabled")
		#print("current states", current_states)
		var checkcount = 0
		for item in current_states:
			#print(item)
			if item == state:
				#var disablingstate : Node = get_node(state)
				state.Disable()
				#state.reparent(Disabled)
				state.isactive = false
				current_states.remove_at(checkcount)
				#print_tree_pretty()
				break
			else:
				checkcount += 1
	
				
