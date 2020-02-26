extends Timer
class_name FrameTimer

func _ready():
	autostart = false
	process_mode = Timer.TIMER_PROCESS_PHYSICS

func start(frames : float = -1):
	.start(frames/60)
