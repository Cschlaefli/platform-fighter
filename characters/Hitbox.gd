extends Area2D

var layer := 0
var active = true

signal hit (damage_dealt, knockback, knockback_growth, hitstun, source, meta)

func _hit(damage_dealt:float, knockback:Vector2, knockback_growth:float, hitstun:float, source = null, meta = {}) :
	emit_signal("hit", damage_dealt, knockback, knockback_growth, hitstun, source, meta)
