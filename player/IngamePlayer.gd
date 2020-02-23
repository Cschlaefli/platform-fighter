extends Node2D
class_name IngamePlayer

var display_name : String
var player_profile : PlayerProfile
var player_number : int = 1
var player_character : PackedScene

var live_character : Character

var lives : int = 3

func test_only():
	player_character = ResourceLoader.load("res://characters/Character.tscn")

func _ready():
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



func set_controls(scheme = []) :
	var prefix = player_format % player_number
	for action in InputMap.get_actions() :
		if prefix in str(action) :
			InputMap.erase_action(action)
	
	for action in InputMap.get_actions() : print(action)
	
	pass

func die():
	lives -= 1
	#if lives <= 0 : emit_signal("loss", self)
	live_character.queue_free()
	live_character = null

func spawn():
	#set spawn pos
	live_character = player_character.instance()
	add_child(live_character)

