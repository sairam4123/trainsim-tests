extends Spatial


func _process(delta):
	if Input.is_key_pressed(KEY_2):
		$CameraROT/Camera.current = true
	if Input.is_key_pressed(KEY_1):
		$CameraROT/Camera.current = false
	if Input.is_key_pressed(KEY_Z):
		$CameraROT/Camera.translation.z += 10 * delta
	if Input.is_key_pressed(KEY_X):
		$CameraROT/Camera.translation.z += -10 * delta
	if Input.is_key_pressed(KEY_Q):
		rotate_y(deg2rad(45 * delta))
	if Input.is_key_pressed(KEY_E):
		rotate_y(deg2rad(-45 * delta))
	if Input.is_key_pressed(KEY_R):
		$CameraROT.rotate_x(deg2rad(45 * delta))
	if Input.is_key_pressed(KEY_F):
		$CameraROT.rotate_x(deg2rad(-45 * delta))
	
	
