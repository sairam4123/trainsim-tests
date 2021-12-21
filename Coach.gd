extends VehicleBody

var speed = 0

var current_sound = null

var previous_position = Vector3.INF

func _process(delta):
	if previous_position == Vector3.INF:
		previous_position = global_transform.origin
	speed = ((previous_position - global_transform.origin).length() / delta)
	
	previous_position = global_transform.origin
	$Label.text = "Speed: %.2f km/h" % (speed * 3.6)
	$StateMachinePlayer.set_param("speed", speed)

func _on_StateMachinePlayer_transited(from, to) -> void:
	pass
#	match to:
#		"Idle":
#			current_sound = yield(SoundPlayer.play_audio_crossfade(current_sound, null, self, 3, 75, $Position3D.translation), "completed")
#		"Speed 10":
###			print("test")
#			current_sound = yield(SoundPlayer.play_audio_crossfade(current_sound, load("res://sounds/CoachSounds/LHBSLOW.wav"), self, 3, $Position3D.translation, 75), "completed")
###			print(current_sound)
#		"Speed 20":
#			current_sound = yield(SoundPlayer.play_audio_crossfade(current_sound, load("res://sounds/CoachSounds/LHBRESTRICTION.wav"), self, 3, $Position3D.translation, 25), "completed")
#		"Speed 40":
#			current_sound = yield(SoundPlayer.play_audio_crossfade(current_sound, load("res://sounds/CoachSounds/LHB40.wav"), self, 3, $Position3D.translation, 75), "completed")
#		"Speed 60":
#			current_sound = yield(SoundPlayer.play_audio_crossfade(current_sound, load("res://sounds/CoachSounds/LHB60.wav"), self, 3, $Position3D.translation, 75), "completed")
#		"Speed 80":
#			current_sound = yield(SoundPlayer.play_audio_crossfade(current_sound, load("res://sounds/CoachSounds/LHB80.wav"), self, 3, $Position3D.translation, 75), "completed")
