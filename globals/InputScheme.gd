extends Node

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

#axis format l/r, u/d
var default_gc = {
	"format" : "controller",
	"move" : {"format": "axis", "up": [1, -1], "down": [1, 1], "left": [0, -1], "right": [0, 1]} ,
	"tilt" : {"format": "axis", "up": [2, 1], "down": [2,-1], "left": [5, 1], "right": [5, -1]} ,
	"attack" : [1],
	"special": [2],
	"grab" : [7],
	"jump" : [3],
	"short_jump" : [0],
	"shield" : [5,4],
	"start" : [9],
	"deadzone" : .05
#	"pad" : {"up": [1,-1], "down": [1, 1], "left": [0,-1], "right": [0, 1]},
}

var default_kb = {
	"format" : "keyboard",
	"move" : {"format": "key", "up": [KEY_UP, KEY_W], "down": [KEY_DOWN, KEY_S], "left": [KEY_LEFT, KEY_A], "right": [KEY_RIGHT, KEY_D]} ,
	"tilt" : {"format": "key", "up": [KEY_I], "down": [KEY_K], "left": [KEY_J], "right": [KEY_L]} ,
	"attack" : [KEY_ENTER],
	"special": [KEY_SHIFT],
	"grab" : [KEY_F],
	"jump" : [KEY_SPACE],
	"short_jump" : [KEY_H],
	"shield" : [KEY_SHIFT],
	"start" : [KEY_ESCAPE],
	"deadzone" : .05
#	"pad" : {"up": [1,-1], "down": [1, 1], "left": [0,-1], "right": [0, 1]},
}
var player_format = "p%s_"

var dirs = ["up", "down", "left", "right"]

func axis_helper(prefix, device, action, action_name, deadzone = .05) :
	for dir in dirs :
		InputMap.add_action(prefix + action_name + "_" + dir, deadzone )
		var mot = InputEventJoypadMotion.new()
		mot.device = device
		mot.axis = action[dir][0]
		mot.axis_value = action[dir][1]
		InputMap.action_add_event(prefix + action_name + "_" + dir, mot )

func button_helper(prefix, device, actions, action_name, deadzone = .05) :
	InputMap.add_action(prefix+action_name, deadzone)
	for input in actions[action_name] :
		var btn = InputEventJoypadButton.new()
		btn.button_index = input
		btn.device = device
		InputMap.action_add_event(prefix+action_name, btn)

func key_helper(prefix, device, actions, action_name, deadzone = .05):
	InputMap.add_action(prefix+action_name, deadzone)
	for input in actions[action_name] :
		var key = InputEventKey.new()
		key.scancode = input
		InputMap.action_add_event(prefix+action_name, key)

func key_helper_axis(prefix, device, action, action_name, deadzone = .05):
	InputMap.add_action(prefix+action_name, deadzone)
	for input in action :
		var key = InputEventKey.new()
		key.scancode = input
		InputMap.action_add_event(prefix+action_name, key)


func set_ingame_controls(player_number : int, device : int, actions = default_kb) :
	var prefix = player_format % player_number
	
	if actions["format"] == "controller" :
		axis_helper(prefix, device, actions["move"], "move", actions["deadzone"])
		axis_helper(prefix, device, actions["tilt"], "tilt", actions["deadzone"])
		button_helper(prefix, device, actions, "attack")
		button_helper(prefix, device, actions, "special")
		button_helper(prefix, device, actions, "grab")
		button_helper(prefix, device, actions, "jump")
		button_helper(prefix, device, actions, "short_jump")
		button_helper(prefix, device, actions, "shield")
		button_helper(prefix, device, actions, "start")
	elif actions["format"] == "keyboard":
		for dir in dirs :
			key_helper_axis(prefix, device, actions["move"][dir], "move_"+dir, actions["deadzone"])
			key_helper_axis(prefix, device, actions["tilt"][dir], "tilt_"+dir, actions["deadzone"])
		key_helper(prefix, device, actions, "attack")
		key_helper(prefix, device, actions, "special")
		key_helper(prefix, device, actions, "grab")
		key_helper(prefix, device, actions, "jump")
		key_helper(prefix, device, actions, "short_jump")
		key_helper(prefix, device, actions, "shield")
		key_helper(prefix, device, actions, "start")

func _ready():
	var attack = InputEventJoypadButton.new()
	
