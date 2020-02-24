extends CanvasLayer

var frame = 0

func _physics_process(delta):
	$Frame.text = "Frame :" + str(frame)
	frame += 1
	if frame > 60 : frame = 0
