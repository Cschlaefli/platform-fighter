extends Control



func _physics_process(delta):
	$Disp/State.text = "State : " + get_parent().get_parent().state
	$Disp/Facing.text = "Facing : " +str( get_parent().get_parent().facing)
