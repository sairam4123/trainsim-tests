extends Camera

export(NodePath) var camera_position_np
onready var camera_pos = get_node(camera_position_np)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_2):
		current = false
	if Input.is_key_pressed(KEY_1):
		current = true
	global_transform.origin = camera_pos.global_transform.origin
	if current:
		if !AudioServer.is_bus_effect_enabled(0, 0):
#			print(AudioServer.is_bus_effect_enabled(0, 0), "Test")
			AudioServer.set_bus_effect_enabled(0, 0, true)
	else:
		if AudioServer.is_bus_effect_enabled(0, 0):
#			print(AudioServer.is_bus_effect_enabled(0, 0), "WOW")
			AudioServer.set_bus_effect_enabled(0, 0, false)
