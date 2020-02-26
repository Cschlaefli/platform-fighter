extends KinematicBody2D
class_name Character

var character_name := "Test"
var damage := .0
var input_prefix = ""
var tap_jump = false
var tap_dash = false

var move_in = Vector2.ZERO
var tilt_in = Vector2.ZERO
var deadzone = .2

var move_strength_x = 0
var move_strength_y = 0

signal die

func die():
	emit_signal("die")

func _unhandled_input(event):
#	var stick = event as InputEventJoypadMotion
#	var btn = event as InputEventJoypadButton
	var move_prev_x = move_in.x
	var move_prev_y = move_in.y
	move_in.y = Input.get_action_strength(input_prefix + "move_down") - Input.get_action_strength(input_prefix + "move_up")
	move_in.x = Input.get_action_strength(input_prefix + "move_right") - Input.get_action_strength(input_prefix + "move_left")
	tilt_in.y = Input.get_action_strength(input_prefix + "tilt_down") - Input.get_action_strength(input_prefix + "tilt_up")
	tilt_in.x = Input.get_action_strength(input_prefix + "tilt_right") - Input.get_action_strength(input_prefix + "tilt_left")
	
#		if move_in.x > 0 :
#			move_prev_x = clamp(move_prev_x, 0, 1)
#		elif move_in.x < 0 :
#			move_prev_x = clamp(move_prev_x, -1, 0)
	
	move_strength_x = move_in.x - move_prev_x
	if move_in.x < 0 : move_strength_x *= -1
	move_strength_y = abs(move_prev_y - move_in.y)
#		if move_strength_x > .1 : print("dash input")
	#probably needs adjustment for some stuff
#		if abs(move_in.x) < deadzone : move_in.x = 0
#		if abs(move_in.y) < deadzone : move_in.y = 0
	if event.is_action_pressed(input_prefix + "jump") :
		_set_state(states.jump)
	if event.is_action_pressed(input_prefix + "short_jump") :
		_set_state(states.jump)
	if event.is_action_pressed(input_prefix + "attack") :
		attack()
	if event.is_action_pressed(input_prefix + "special") :
		special()
	if event.is_action_pressed(input_prefix + "grab"):
		grab()
	if event.is_action_pressed(input_prefix + "shield"):
		shield_timer.start(tech_input_window)
		shield()

var tech_input_window = .25
onready var shield_timer = $Timers/ShieldTimer

###character impemented

func shield():
	pass

func grab():
	pass

func attack():
	pass

func special():
	pass

onready var hitstun_timer = $Timers/HitstunTimer

func _on_hit(_damage:float, knockback:Vector2, knockback_growth:float, hitstun: float, source = null, meta = {}) :
	damage += _damage
	velocity = knockback * (weight/100) * knockback_mod * ((damage+1)/100)
	hitstun_timer.start(hitstun)
	_set_state(states.hitstun)

######################
#Movement variables###
######################

func init_stats():
	pass

var velocity := Vector2.ZERO

var weight := 100.0
var knockback_mod := 1

var gravity := 16.0* Global.CELL_HEIGHT
var terminal_velocity := 6.0 * Global.CELL_HEIGHT
var fastfall_terminal := 8.0 * Global.CELL_HEIGHT
var jump_height := 3.5
var short_jump_height := jump_height * .5
var double_jump_height := 2.5

var run_speed := 4.0 * Global.CELL_WIDTH
var walk_speed := 1.0 * Global.CELL_WIDTH
var air_speed := 5.0 * Global.CELL_WIDTH

var dash_speed := 7.25 * Global.CELL_WIDTH
var dash_time := .25

var air_accel = 20 * Global.CELL_WIDTH
var ground_accel = 20 * Global.CELL_WIDTH

var air_friction = 5* Global.CELL_WIDTH
var ground_friction = 15 * Global.CELL_WIDTH

var max_jumps := 1

var jumps := max_jumps
var grounded = true

var facing = -1

########################################
############State Logistics###########
########################################

func _ready():
	init_stats()
	_add_states()
	_set_state(states.fall)

func _add_states():
	_add_state("stand")
	_add_state("crouch")
	_add_state("attack")
	_add_state("air_attack")
	_add_state("jump")
	_add_state("fall")
	_add_state("fastfall")
	_add_state("helpless_fall")
	_add_state("grounded")
	_add_state("ledge")
	_add_state("walk")
	_add_state("run")
	_add_state("hitstun")
	_add_state("block")
	_add_state("dash")
	_add_state("land")
	_add_state("slide")
	_add_state("turn")

func _state_logic(delta:float):
	delta *= Engine.time_scale
	_check_grounded()
	_handle_gravity(delta)
	_handle_move_input(delta)
	_apply_movement(delta)

func _check_grounded() :
	grounded = $GroundCheck.is_colliding()
#	if !$GroundCheck.is_colliding() :
#		if $Timers/CayoteTimer.time_left > 0:
#			grounded = true
#		else :
#			grounded = false
#	else :
#		grounded = true

func _handle_gravity(delta:float):
	match state :
		states.fall, states.jump, states.helpless_fall :
			if velocity.y < terminal_velocity :
				velocity.y += gravity*delta
		states.fastfall :
			if velocity.y < fastfall_terminal :
				velocity.y += gravity*delta

var input_sensitivity = .1

func _handle_move_input(delta:float) :
	var dir = sign(move_in.x)
	if state in [states.fall, states.fastfall, states.helpless_fall, states.jump] and move_in.y > .1 :
		set_collision_mask_bit(1, false)
		$GroundCheck.set_collision_mask_bit(1, false)
	else:
		$GroundCheck.set_collision_mask_bit(1, true)
		set_collision_mask_bit(1, true)
	
	match state :
		states.stand :
			velocity.x = 0
		states.walk :
			velocity.x -= sign(velocity.x - walk_speed*dir)*delta*ground_accel
		states.dash :
			velocity.x -= sign(velocity.x - run_speed*dir)*delta*ground_friction
		states.slide :
			velocity.x -= sign(velocity.x)*ground_friction*delta
		states.fall, states.fastfall, states.helpless_fall, states.jump :
			var diff = sign(velocity.x - air_speed*dir)
			var accel = air_accel if diff != dir and dir != 0 else air_friction
			velocity.x -= sign(velocity.x - air_speed*dir)*delta*accel
		states.hitstun :
			pass
		states.run :
			velocity.x -= sign(velocity.x - run_speed*dir)*delta*ground_accel
		states.grounded :
			velocity.x = 0
	
	if grounded and dir != 0 : facing = dir

func _apply_movement(delta:float):
	move_and_slide(velocity, Vector2.UP)

########################################
############State Transitions###########
########################################

var state = null  setget _set_state
var previous_state = null
var states := {}

func _add_state(state_name) :
	states[state_name] = state_name

func _physics_process(delta):
	if state :
		_state_logic(delta)
		var trans = _get_transition(delta)
		if trans : _set_state(trans)

func _set_state(new_state) :
	previous_state = state
	state = new_state
	if previous_state :
		_exit_state(previous_state, new_state)
	if new_state :
		_enter_state(new_state, previous_state)

onready var landing_lag_timer = $Timers/LandingTimer
onready var dash_timer = $Timers/DashTimer
onready var tech_timer = $Timers/TechTimer
var tech_window = .1


func _get_transition(delta:float):
	
	if grounded :
		
		var dir = sign(move_in.x)
		
		match state:
			states.grounded :
				if !tech_timer.is_stopped() :
					if Input.is_action_pressed(input_prefix+ "shield") && !shield_timer.is_stopped() :
						if move_in.x > input_sensitivity :
							velocity.x = 500
							return states.slide
							pass #roll right
						elif move_in.x < -input_sensitivity :
							velocity.x = 500
							return states.slide
							pass #roll left
						else :
							velocity.x = 0
							return states.slide
							pass #tech in place
				else :
					if move_in.x > input_sensitivity :
						velocity.x = 500
						return states.slide
						pass #roll right
					if move_in.x < -input_sensitivity :
						velocity.x = 500
						return states.slide
						pass #roll left
			states.hitstun :
				if hitstun_timer.is_stopped() :
					return states.slide
			states.land :
				if landing_lag_timer.is_stopped() :
					var v = abs(velocity.x)
					if v >= walk_speed *.5 :
						return states.run
					elif v > 30 : 
						return states.walk
					else :
						return states.stand
			states.jump, states.fall, states.fastfall, states.air_attack :
				return states.land
			states.helpless_fall :
				tech_timer.start()
				return states.grounded
			states.dash :
				if dash_timer.is_stopped():
					return states.run
				if dir != 0 and dir != sign(velocity.x) :
					return states.dash
			states.run, states.walk, states.stand:
				if dir != 0 : 
					if move_strength_x > input_sensitivity :
						return states.dash
					elif state == states.stand :
						return states.walk
				elif abs(velocity.x) > 10 : 
					return states.slide
			states.slide :
				if dir != 0 : 
					if move_strength_x > input_sensitivity :
						return states.dash
					elif states.stand :
						return states.walk
				elif abs(velocity.x) < 10 :
					return states.stand
	else :
		match state :
			states.hitstun :
				if hitstun_timer.is_stopped() :
					return states.helpless_fall
			states.fall :
				if move_in.y > .25 :
					velocity.y = fastfall_terminal
					return states.fastfall
			states.jump :
				if velocity.y >= -10 : 
					return states.fall
			states.walk, states.run, states.land, states.slide, states.stand :
				return states.fall
	return null

func _exit_state(old_state, new_state):
	match old_state:
		states.jump :
			$GroundCheck.enabled = true
#		states.turn :
#			facing *= -1
	match new_state:
		states.land, states.ledge :
			jumps = max_jumps
		states.dash :
			move_strength_x = 0
			dash_timer.start(dash_time)
			velocity.x = dash_speed * sign(move_in.x)

func _enter_state(new_state, old_state):
	match new_state:
		states.jump :
			if grounded :
				$GroundCheck.enabled = false
				if Input.is_action_pressed(input_prefix + "jump") :
					velocity.y = -sqrt(2*gravity* jump_height * Global.CELL_HEIGHT *Engine.time_scale)
				if Input.is_action_pressed(input_prefix + "short_jump") :
					velocity.y = -sqrt(2*gravity* short_jump_height * Global.CELL_HEIGHT * Engine.time_scale)
				$Timers/JumpTimer.start(.018)
			elif jumps > 0 and $Timers/JumpTimer.time_left == 0 :
				jumps -= 1
				velocity.y = -sqrt(2*gravity*double_jump_height * Global.CELL_HEIGHT) *Engine.time_scale
			else :
				pass
	pass
