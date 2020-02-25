extends Area2D



func _on_Death_body_entered(body):
	if body is Character :
		body.die()
