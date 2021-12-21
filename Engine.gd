extends VehicleBody


var throttle = 0
var current_pitch = 0.01
var new_throttle = 0
var starting_throttle = 0
var new_pitch = 0.02
var horn_pressed
var reverser = 1

func _ready():
	$StateMachinePlayer.set_param("throttle", throttle)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_P and $StateMachinePlayer.current == "Stopped" and event.pressed:
			$StateMachinePlayer.set_trigger("start_button_pressed")
		elif event.scancode == KEY_P and $StateMachinePlayer.current != "Stopped" and event.pressed:
			$StateMachinePlayer.set_trigger("stop_button_pressed")
		elif event.scancode == KEY_SPACE and event.pressed:
			if !$HornPlayer.is_playing():
				if !horn_pressed:
					$HornPlayer.play()
					horn_pressed = true
			if $HornPlayer.get_playback_position() > 3.38:
				$HornPlayer.seek(0.61)
				horn_pressed = true
		elif event.scancode == KEY_SPACE and !event.pressed:
			horn_pressed = false
			if $HornPlayer.is_playing():
				$HornPlayer.stop()
				$HornPlayer.play(3.38)
				horn_pressed = false

func _process(delta):
	if Input.is_key_pressed(KEY_D):
		if Input.is_key_pressed(KEY_CONTROL):
			new_throttle = 110
			starting_throttle = throttle
		else:
			throttle += delta * 5
			new_throttle = throttle
	elif Input.is_key_pressed(KEY_A):
		if Input.is_key_pressed(KEY_CONTROL):
			new_throttle = -10
			starting_throttle = throttle
		else:
			throttle -= delta * 5
			new_throttle = throttle
	if Input.is_key_pressed(KEY_W):
		reverser += 1
	if Input.is_key_pressed(KEY_S):
		reverser += -1
#	if Input.is_key_pressed(KEY_K):
#		steering += 1 * delta
#	if Input.is_key_pressed(KEY_L):
#		steering += -1 * delta
	reverser = clamp(reverser, -1, 1)
#	throttle += delta * 0.1 * (new_throttle - throttle)
	var throttle_progress = abs((throttle - starting_throttle)/((new_throttle - starting_throttle)+0.001))
	throttle += delta * ease(throttle_progress+0.001, -0.4) * (new_throttle - throttle)
	throttle = clamp(throttle, 0, 100)
	
	engine_force = -throttle * 100 * reverser * delta
#	steering = 0
	$StateMachinePlayer.set_param("throttle", throttle)
	$Label.text = "Throttle: %d" % throttle 
	var progress = abs((($IdleSoundPlayer.pitch_scale) - current_pitch)/((new_pitch - current_pitch)+0.001))
#	$IdleSoundPlayer.pitch_scale = move_toward($IdleSoundPlayer.pitch_scale, new_pitch, delta/10)
	$IdleSoundPlayer.pitch_scale += delta * ease(progress+0.001, -0.4) * (new_pitch - $IdleSoundPlayer.pitch_scale)
#	prints(abs(($IdleSoundPlayer.pitch_scale - current_pitch+0.001)/(new_pitch - current_pitch+0.001)), new_pitch, current_pitch, new_pitch-current_pitch)
	if is_equal_approx(new_pitch, current_pitch):
		current_pitch = new_pitch
	if is_equal_approx($IdleSoundPlayer.pitch_scale, 0.01):
		if $IdleSoundPlayer.is_playing():
			$IdleSoundPlayer.stop()
#	$IdleSoundPlayer.pitch_scale = (speed / 20) + 0.01
#	print((new_pitch-$IdleSoundPlayer.pitch_scale)/float(new_pitch))
	
	if $StateMachinePlayer.get_current() == "Throttling":
		new_pitch = 1 + range_lerp(throttle, 0, 100, 0, 5) * delta * 8
	

func _on_StateMachinePlayer_transited(from, to):
	if from == "Stopped" and to == "Starting":
		$PantoUpPlayer.play()
		print("starting engine")
		yield($PantoUpPlayer, "finished")
		$StateMachinePlayer.set_trigger("started")
	if from in ["Idle", "Throttling"] and to == "Stopping":
		new_pitch = 0.01
		current_pitch = $IdleSoundPlayer.pitch_scale
		print("Stopping Engine")
		$PantoDownPlayer.play()
		yield($PantoDownPlayer, "finished")
		$StateMachinePlayer.set_trigger("stopped")
	if from == "Idle" and to == "Throttling":
		new_pitch = 1.15
		current_pitch = $IdleSoundPlayer.pitch_scale
		$IdleSoundPlayer.unit_db = linear2db(0.75 - 0.005)
	if from == "Throttling" and to == "Idle":
		new_pitch = 1
		current_pitch = $IdleSoundPlayer.pitch_scale
		$IdleSoundPlayer.unit_db = linear2db(0.75)
		
	match to:
		"Idle":
			print("Idling")
			if not $IdleSoundPlayer.is_playing():
				$IdleSoundPlayer.play()
#			$IdleSoundPlayer.pitch_scale = 1
			new_pitch = 1
			current_pitch = $IdleSoundPlayer.pitch_scale
			$IdleSoundPlayer.unit_db = linear2db(0.75)
			
		"Throttling":
			print("Throttling!")
		"Stopped":
			print("Stopped")

