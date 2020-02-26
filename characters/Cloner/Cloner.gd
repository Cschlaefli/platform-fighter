extends Character

var is_clone = false
var clone_count = 0
var max_clones = 10

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
	
	weight = 90
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
	emit_signal("clone_hit", 15)
	clone_count -= 1

func _on_hit(_damage:float, knockback:Vector2, knockback_growth:float, hitstun:float, source = null, meta = {}) :
	._on_hit(_damage, knockback, knockback_growth, hitstun, source, meta)
	emit_signal("clone_hit", _damage)

func die():
	emit_signal("die")
	if is_clone :
		queue_free()

signal clone_hit (_damage)

func sub_hit(_damage):
	damage += _damage

func down_special():
	if is_clone or clone_count > max_clones : return
	var c = get_parent().player_character.instance()
	c.is_clone = true
	c.damage = damage
	connect("die", Callable(c, "die"))
	connect("clone_hit", Callable(c, "sub_hit"))
	var s = self
	c.connect("clone_hit", Callable(s, "sub_hit"))
	c.connect("die", Callable(s, "clone_death"))
	c.position = position + Vector2(50, 0) * facing
	c.input_prefix = input_prefix
	clone_count += 1
	get_parent().add_child(c)

func special():
	if move_in.y > input_threshold :
		down_special()

