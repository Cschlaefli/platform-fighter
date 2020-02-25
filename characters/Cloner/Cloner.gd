extends Character

var is_clone = false


func init_stats() :
	gravity = 16.0* Global.CELL_HEIGHT
	terminal_velocity = 6.0 * Global.CELL_HEIGHT
	fastfall_terminal = 8.0 * Global.CELL_HEIGHT
	jump_height = 3.5
	short_jump_height = jump_height * .5
	double_jump_height = 2.5
	
	run_speed = 4.0 * Global.CELL_WIDTH
	walk_speed = 1.0 * Global.CELL_WIDTH
	air_speed = 5.0 * Global.CELL_WIDTH
	
	dash_speed = 7.25 * Global.CELL_WIDTH
	dash_time = .25
	
	air_accel = 20 * Global.CELL_WIDTH
	ground_accel = 20 * Global.CELL_WIDTH
	
	air_friction = 5* Global.CELL_WIDTH
	ground_friction = 15 * Global.CELL_WIDTH
	
	max_jumps = 1


###character impemented

func shield():
	pass

func grab():
	pass

func attack():
	pass

var input_threshold = .5

func clone_death():
	damage += 15

func die():
	emit_signal("die")
	if is_clone :
		queue_free()

func down_special():
	if is_clone : return
	var c = get_parent().player_character.instance()
	c.is_clone = true
	connect("die", Callable(c, "die"))
	var s = self
	c.connect("die", Callable(s, "clone_death"))
	c.position = position + Vector2(50, 0) * facing
	c.input_prefix = input_prefix
	get_parent().add_child(c)

func special():
	if move_in.y > input_threshold :
		down_special()
