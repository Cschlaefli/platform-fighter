extends Node2D
class_name IngamePlayer

var display_name : String
var player_profile
var player_number : int = 1
var player_character : PackedScene

var live_character : Character

var lives : int = 3

func test_only():
	player_character = ResourceLoader.load("res://characters/BaseCharacter.tscn")

func _ready():
	set_controls()
	test_only()
	spawn()
	if player_profile :
		display_name = player_profile.display_name
		#set_control scheme
	else : 
		display_name = live_character.character_name
		

var action_format = "p_%s"

func set_controls(scheme = {}) :
	for action in InputMap.get_actions() :
		print(action)
		
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

