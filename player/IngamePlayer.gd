extends Node2D
class_name IngamePlayer

var display_name : String
var player_profile : PlayerProfile
export var player_number : int = 0
export var device : int = 0
var player_character : PackedScene
var tap_jump = false
var tap_dash = false

var damage := 0.0

var live_character : Character

var lives : int = 3

func test_only():
	player_character = ResourceLoader.load("res://characters/Cloner/Cloner.tscn")

func _ready():
	$Debug.ingame_player = self
	set_controls()
	test_only()
	spawn()
	if player_profile :
		display_name = player_profile.display_name
		#set_control scheme
	else : 
		display_name = live_character.character_name
		

func _input(event):
	var button = event as InputEventJoypadButton
	var motion = event as InputEventJoypadMotion
	if button :
#		print(button.device)
#		print(button.button_index)
		pass
	if motion :
#		print(motion.device)
#		print(motion.axis)
#		print(motion.axis_value)
		pass


var player_format = "p%s_"

#GameCube controller
#right stick l/r axis 0, u/d axis 1
#left stick l/r axis 5, u/d axis 2
#right trigger axis 4 button 5
#left trigger axis 3 button 4
#Z btn 7
#X btn 0
#A btn 1
#B btn 2
#Y btn 3
#Start 9
#D-up 12
#D-down 13+14?
#D-right 13+15?
#D-left 14+15



func set_controls(scheme = InputScheme.default_gc) :
	if player_number == 1 : scheme = InputScheme.default_kb
	var prefix = player_format % player_number
	for action in InputMap.get_actions() :
		if prefix in str(action) :
			InputMap.erase_action(action)
	
	if player_profile :
		InputScheme.set_ingame_controls(player_number, device, player_profile.control_scheme)
	else :
		InputScheme.set_ingame_controls(player_number, device, scheme)


func die():
	lives -= 1
	#if lives <= 0 : emit_signal("loss", self)
	live_character.queue_free()
	live_character = null
	yield(get_tree().create_timer(1),"timeout")
	spawn()

func spawn():
	#set spawn pos
	live_character = player_character.instance()
	live_character.hitbool = player_number + 9
	live_character.input_prefix = player_format % player_number
	add_child(live_character)
#	call_deferred("connect_char")
	var s = self
	live_character.connect("die", Callable(s, "die"))


func connect_char():
	pass


func _on_UseKeyboard_pressed():
	set_controls(InputScheme.default_kb) 

func _on_UseController_pressed():
	set_controls(InputScheme.default_gc)
