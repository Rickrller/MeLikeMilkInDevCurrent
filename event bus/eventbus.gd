extends Node

var parrydamage = 25

#class_name multistate
@warning_ignore("unused_signal")
signal switch_activity(state: Node, new_activity: String)
@warning_ignore("unused_signal")
signal Transistioned(state: Node, new_state_name: String)
@warning_ignore("unused_signal")
signal grantitem(name: String)
@warning_ignore("unused_signal")
signal flashbang()
@warning_ignore("unused_signal")
signal parrykill()
@warning_ignore("unused_signal")
signal landedparry()
