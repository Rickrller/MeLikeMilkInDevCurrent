extends CenterContainer

@export var look_deadzone := 0.1

var moved = false
var movedcam = false
var parried = false
var punched = false
var dashed = false
var pressedp = false

@export var enemyspawned = false
@export var enemydefeated = false

func wait_until(predicate: Callable) -> void:
	if self:
		while not predicate.call():
			await Engine.get_main_loop().process_frame

func _ready() -> void:
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "Let's go over the basics"
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "Tap P, then use your mouse to look around"
	await wait_until(func(): return movedcam == true)
	$DialogueLabel.text = "Great!"
	await get_tree().create_timer(2).timeout
	$DialogueLabel.text = "Use WASD to move your character"
	await wait_until(func(): return moved == true)
	$DialogueLabel.text = "Good! You can also tap space to jump"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "Left click to throw punches"
	await wait_until(func(): return punched == true)
	$DialogueLabel.text = "Just like that!"
	await get_tree().create_timer(3).timeout
	$DialogueLabel.text = "This will be your most basic attack"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "Next, tap F to initiate a parry"
	await wait_until(func(): return parried == true)
	$DialogueLabel.text = "Awesome!"
	await get_tree().create_timer(2).timeout
	$DialogueLabel.text = "parry acts as a counter for enemy attacks"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "and the enemies light up when parriable"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "now, press shift to perform a dash"
	await wait_until(func(): return dashed == true)
	$DialogueLabel.text = "amazing!"
	await get_tree().create_timer(2).timeout
	$DialogueLabel.text = "dash + jump results in a long jump"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "It goes much further than a normal dash!"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "Now then, ready for an actual test?"
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "Proceed down the road"
	await wait_until(func(): return enemyspawned == true)
	$DialogueLabel.text = "Parry the apple to grab it!"
	await wait_until(func(): return enemydefeated == true)
	$DialogueLabel.text = "If you right click while holding a fruit"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "You cast an ability related to said fruit"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "You can also press E to eat it!"
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "Eating fruits grants nutrients"
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "and each fruit gives a different nutrient!"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "If you don't manage your nutrients"
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "Your stats get debuffed..."
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "So make sure to keep track!"
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "And with that, I think you are ready!"
	await get_tree().create_timer(4).timeout
	$DialogueLabel.text = "Go into that house to exit the tutorial!"
	await get_tree().create_timer(5).timeout
	$DialogueLabel.text = "Have fun!"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		moved = true
	if Input.is_action_just_pressed("parry"):
		parried = true
	if Input.is_action_just_pressed("punch"):
		punched = true
	if Input.is_action_just_pressed("shift"):
		dashed = true
	if Input.is_action_just_pressed("camera_toggle"):
		pressedp = true

func _input(event: InputEvent) -> void:
	if movedcam:
		return
	if event is InputEventMouseMotion and pressedp == true:
		movedcam = true
