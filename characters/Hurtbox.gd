extends Area2D

var layer := 0
var active = false

var damage = 5
var knockback = Vector2.LEFT * Global.CELL_WIDTH * 20 + (Vector2.UP *Global.CELL_WIDTH * 35)
var knockback_growth = 1
export var hitstun = 8
var source = self
var meta = {}

signal hit (hitbox)

func _on_Hurtbox_area_entered(area):
	if area.has_method("_hit") :
		emit_signal("hit", area)
		knockback.x *= sign(area.global_position.x - global_position.x)
		area._hit(damage, knockback, knockback_growth, hitstun, source, meta)
